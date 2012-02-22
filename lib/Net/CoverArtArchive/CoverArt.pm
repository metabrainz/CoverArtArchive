package Net::CoverArtArchive::CoverArt;
use Moose;
use namespace::autoclean;

has types => (
    isa => 'ArrayRef[Str]',
    is => 'ro',
);

has is_front => (
    isa => 'Bool',
    is => 'ro',
    init_arg => 'front'
);

has is_back => (
    isa => 'Bool',
    is => 'ro',
    init_arg => 'back'
);

has comment => (
    isa => 'Str',
    is => 'ro',
);

has image => (
    isa => 'Str',
    is => 'ro',
);

has large_thumbnail => (
    isa => 'Str',
    is => 'ro',
);

has small_thumbnail => (
    isa => 'Str',
    is => 'ro',
);

has approved => (
    isa => 'Bool',
    is => 'ro',
);

has edit => (
    isa => 'Str',
    is => 'ro',
);

__PACKAGE__->meta->make_immutable;
1;
