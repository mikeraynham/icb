package ICB::Static::CSS;

use strict;
use warnings;

use Carp;
use File::Which;
use IPC::System::Simple qw/ capturex /;

use Moose;

with qw/
    ICB::Role::Static
/;

has lessc_bin  => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

sub _build_minifier {
    require CSS::Minifier::XS;
    return \&CSS::Minifier::XS::minify;
}

sub _build_lessc_bin {
    my $bin = which('lessc') // '/usr/local/bin/lessc';

    croak 'Cannot find lessc binary'
        unless -f $bin;

    return $bin;
}

sub _content_type { 'text/css' }

sub _process {
    my $self    = shift;
    my $file    = shift;
    my $content = capturex( $self->lessc_bin, $file->slurp ); 

    return $self->minify( $content );
}

1;
