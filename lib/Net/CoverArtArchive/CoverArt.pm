package Net::CoverArtArchive::CoverArt;
use Moose;
use namespace::autoclean;

use Moose::Util::TypeConstraints;

coerce 'Bool', from class_type('JSON::XS::Boolean'), via { $_ ? 1 : 0 };

has id => (
    isa => 'Int',
    is => 'ro',
    required => 1
);

has types => (
    isa => 'ArrayRef[Str]',
    is => 'ro',
);

has is_front => (
    isa => 'Bool',
    is => 'ro',
    init_arg => 'front',
    coerce => 1
);

has is_back => (
    isa => 'Bool',
    is => 'ro',
    init_arg => 'back',
    coerce => 1
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
    coerce => 1
);

has edit => (
    isa => 'Str',
    is => 'ro',
);

__PACKAGE__->meta->make_immutable;
1;
