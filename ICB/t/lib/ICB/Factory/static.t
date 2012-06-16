use strict;
use warnings;

use Test::More;

use ICB::Factory::Static;

{
    my $factory = ICB::Factory::Static->new( content_type => 'text/css' );
    my $css     = $factory->construct(
        base => 'css',
        date => '20120101',
        time => '120000',
        path => 'custom.css',
    );

    isa_ok( $css, 'ICB::Static::CSS' );
}

done_testing();
