package ICB::Static::CSS;

use strict;
use warnings;

use Moose;

with qw/
    ICB::Role::Static
/;

sub _build_minifier {
    require CSS::Minifier::XS;
    return \&CSS::Minifier::XS::minify;
}

sub _content_type () { 'text/css' }

1;
