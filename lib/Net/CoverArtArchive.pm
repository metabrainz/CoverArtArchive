package Net::CoverArtArchive;
use Moose;
use namespace::autoclean;

our $VERSION = '1.00';

use LWP::UserAgent;
use Net::CoverArtArchive::CoverArt;
use JSON::Any;

has json => (
    default => sub { JSON::Any->new( utf8 => 1 ) },
    lazy => 1,
    is => 'ro'
);

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
        my $index = $self->json->jsonToObj($res->decoded_content);

        return [
            map {
                Net::CoverArtArchive::CoverArt->new(
                    %$_,
                    large_thumbnail => $_->{thumbnails}{large},
                    small_thumbnail => $_->{thumbnails}{small},
                )
              } @{ $index->{images} }
          ];
    }
    else {
        return [];
    }
}

__PACKAGE__->meta->make_immutable;
1;
