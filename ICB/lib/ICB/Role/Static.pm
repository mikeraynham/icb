package ICB::Role::Static;

use strict;
use warnings;

use Moose::Role;

requires qw/
    _content_type
/;

sub handles_content_type {
    my $self         = shift;
    my $content_type = shift;
    return $self->_content_type eq $content_type;
}

1;
