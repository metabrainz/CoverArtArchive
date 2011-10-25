package Net::CoverArtArchive::CoverArt;
use Moose;

has artwork => (
    is => 'ro',
    required => 1
);

has _path_split => (
    is => 'ro',
    lazy => 1,
    default => sub {
        [ shift->artwork =~ /([^\-]+)-(\d+)\.jpg/ ]
    }
);

sub type { shift->_path_split->[0] }
sub page { shift->_path_split->[1] }

sub large_thumbnail {
    my $self = shift;
    my $uri = $self->artwork;
    $uri =~ s/\.jpg/-500\.jpg/;
    return $uri;
}

sub small_thumbnail {
    my $self = shift;
    my $uri = $self->artwork;
    $uri =~ s/\.jpg/-250\.jpg/;
    return $uri;
}

1;
