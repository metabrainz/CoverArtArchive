package Net::CoverArtArchive;
# ABSTRACT: Query the coverartarchive.org

use Moose;
use namespace::autoclean;

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
__END__

=head1 SYNOPSIS

    use Net::CoverArtArchive

    # Get a listing of all available artwork
    my $caa = Net::CoverArtArchive->new;
    my $all_artwork = $caa->find_available_artwork('4331ea73-77e1-3213-a840-5e4e74180f93');

    # Do things with single Net::CoverArtArchive::CoverArt objects
    my ($front) = grep { $_->is_front } @$all_artwork;
    printf "Checkout this cool artwork at %s!\n", $front->large_thumbnail;

=method find_available_artwork

    find_available_artwork($musicbrainz_release_mbid)

Get's a list of L<Net::CoverArtArchive::CoverArt> objects, where each object
represents a piece of artwork for a given release.

Returns an array reference of L<Net::CoverArtArchive::CoverArt> objects.

=cut
