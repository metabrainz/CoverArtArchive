package Net::CoverArtArchive::CoverArt;
# ABSTRACT: A single cover art image

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

=attr id

The ID of this cover art. Fairly internal, you probably don't need to do
anything with this.

=attr types

An array reference of strings, where each string describes the type of this
image. For example, an image might be about a specific medium, or it might be a
page in a booklet.

=attr is_front

Whether this image is considered to be the 'frontiest' image of a release.

=attr is_back

Whether this image is considered to be the 'backiest' image of a release.

=attr comment

A string potentially describing additionally information about this image. Free
text and unstructured.

=attr image

The full URL of the image

=attr large_thumbnail

A URL to the large thumbnail of this image.

=attr small_thumbnail

A URL to the small thumbnail of this image.

=attr approved

Whether this image has passed peer review.

=attr edit

A URL to the MusicBrainz edit that originally added this piece of artwork.

=cut
