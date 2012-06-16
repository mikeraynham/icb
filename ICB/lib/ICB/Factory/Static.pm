package ICB::Factory::Static;

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

has file_type    => (
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
        filter      => sub {
            my $module = shift;
            my $type   = shift;
            $module->handles_type( $type );
        },
    );
}

sub construct {
    my $self = shift;

    return $self->_finder->construct(
        {
            content_type => $self->content_type,
            file_type    => $self->file_type,
        },
        @_
    ) or croak 'Cannot find an ICB::Static module that handles ' .
        $self->content_type;
};

1;
