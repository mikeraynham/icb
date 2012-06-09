package ICB::Static::CSS;

use strict;
use warnings;

use autodie qw/ :all /;
use Carp;

use Moose;
use MooseX::Types::Path::Class;

with qw/
    ICB::Role::Static
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

sub _build_minifier {
    require CSS::Minifier::XS;
    return \&CSS::Minifier::XS::minify;
}

sub _content_type {
    'text/css';
}

1;
