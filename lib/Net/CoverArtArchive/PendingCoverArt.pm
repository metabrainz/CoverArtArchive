package Net::CoverArtArchive::PendingCoverArt;
use Moose;
use namespace::clean;

has artwork => (
    is => 'ro',
    required => 1
);

sub type { 'pending' }
sub page { undef }

sub large_thumbnail { return shift->artwork }
sub small_thumbnail { return shift->artwork }

__PACKAGE__->meta->make_immutable;
1;
