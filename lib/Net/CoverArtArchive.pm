package Net::CoverArtArchive;
use Moose;
use namespace::autoclean;

our $VERSION = '1.00';

use List::UtilsBy qw( partition_by nsort_by );
use LWP::UserAgent;
use Net::CoverArtArchive::CoverArt;
use Net::CoverArtArchive::PendingCoverArt;
use XML::XPath;

has lwp => (
    isa => 'LWP::UserAgent',
    is => 'ro',
    required => 1,
    default => sub {
        my $lwp = LWP::UserAgent->new;
        $lwp->env_proxy;
        return $lwp;
    }
);

has cover_art_archive_prefix => (
    isa => 'Str',
    is => 'ro',
    default => 'http://coverartarchive.org',
    required => 1
);

sub _new_cover_art {
    my ($host, $release_mbid, $file) = @_;
    my $class = $file =~ /^\.pending/
        ? 'Net::CoverArtArchive::PendingCoverArt'
        : 'Net::CoverArtArchive::CoverArt';
    return $class->new(artwork => "$host/release/$release_mbid/$file");
}

sub find_available_artwork {
    my ($self, $release_mbid) = @_;

    my $host = $self->cover_art_archive_prefix;
    my $res = $self->lwp->get("$host/release/$release_mbid");
    if ($res->is_success) {
        my $xp = XML::XPath->new( xml => $res->content );
        my @artwork = map {
            _new_cover_art($host, $release_mbid, $_)
        }
        map {
            my $path = $_;
            $path =~ s/mbid-[a-fA-F\-0-9]{36}\-//;
            $path;
        }
        # Skip thumbnails.
        grep {
            $_ =~ /^\.pending/ ||
            $_ =~ /([a-z]+)-(\d+)\.jpg$/
        }
        map { $xp->find('Key', $_) }
            $xp->find('/ListBucketResult/Contents')->get_nodelist;

        return partition_by { $_->type } nsort_by { $_->page } @artwork
    }
    else {
        return ();
    }
}

sub find_artwork {
    my ($self, $release_mbid, $type, $page) = @_;
    my $host = $self->cover_art_archive_prefix;
    my $url = "$host/release/$release_mbid/$type-$page.jpg";
    my $res = $self->lwp->head($url);
    if ($res->is_success) {
        Net::CoverArtArchive::CoverArt->new(
            artwork => $url
        );
    }
    else {
        return undef;
    }
}

__PACKAGE__->meta->make_immutable;
1;
