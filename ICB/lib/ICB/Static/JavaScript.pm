package ICB::Static::JavaScript;

use strict;
use warnings;

use Moose;

with qw/
    ICB::Role::Static
/;

sub _build_minifier {
    require JavaScript::Minifier::XS;
    return \&JavaScript::Minifier::XS::minify;
}

sub content_type { 'text/javascript' }
sub file_type    { 'js'              }

1;
