package Net::CoverArtArchive;
use Moose;

our $VERSION = '1.00';

use List::UtilsBy qw( partition_by nsort_by );
use LWP::UserAgent;
use Net::CoverArtArchive::CoverArt;
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

sub find_available_artwork {
    my ($self, $release_mbid) = @_;

    my $res = $self->lwp->get('http://s3.amazonaws.com/mbid-' . $release_mbid);
    if ($res->is_success) {
        my $xp = XML::XPath->new( xml => $res->content );
        my @artwork = map {
            Net::CoverArtArchive::CoverArt->new(
                artwork => "http://s3.amazonaws.com/mbid-$release_mbid/$_"
            );
        }
        # Skip thumbnails and internal images. Should be part of our web service,
        # but upon discussion with coverartarchive developers, it's apparently
        # "too costly" in some way.
        grep {
            $_ !~ /^\./ &&
            $_ =~ /([a-z]+)-(\d+)\.jpg$/ }
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
    my $url = 'http://s3.amazonaws.com/mbid-' . $release_mbid . '/' .
        "mbid-$release_mbid-$type-$page.jpg";
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

1;
