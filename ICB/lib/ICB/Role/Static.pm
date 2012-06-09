package ICB::Role::Static;

use strict;
use warnings;

use Moose::Role;
use MooseX::Types::Path::Class;

requires qw/
    _content_type
/;

has minifier   => (
    is         => 'ro',
    lazy_build => 1,
    traits     => ['Code'],
    handles    => { minify  => 'execute' },
);

has date_stamp => (
    is         => 'ro',
    isa        => 'Int',
    required   => 1,
);

has time_stamp => (
    is         => 'ro',
    isa        => 'Int',
    required   => 1,
);

has path       => (
    is         => 'ro',
    isa        => 'Path::Class::File',
    required   => 1,
    coerce     => 1,
);

sub handles_content_type {
    my $self         = shift;
    my $content_type = shift;
    return $self->_content_type eq $content_type;
}

1;
