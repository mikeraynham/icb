package ICB::Static::Factory;

use strict;
use warnings;

use Carp;
use Module::PluginFinder;

use Moose;

has content_type => (
    is           => 'ro',
    isa          => 'Str',
    required     => 1,
);

has _finder      => (
    is           => 'ro',
    isa          => 'Module::PluginFinder',
    lazy_build   => 1,
    init_arg     => undef,
);

sub _build__finder {
    return Module::PluginFinder->new(
        search_path => 'ICB::Static',
        typefunc    => '_content_type',
    );
}

sub construct {
    my $self = shift;

    return $self->_finder->construct( $self->content_type, @_ )
        or croak 'Cannot find an ICB::Static module that handles ' .
           $self->content_type;
};

1;
