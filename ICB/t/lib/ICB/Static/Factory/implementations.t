use strict;
use warnings;

use Test::More;

use ICB::Static::Factory;

{
    my $factory = ICB::Static::Factory->new( content_type => 'text/css' );
    my $css     = $factory->construct(
        date_stamp => '20120101',
        time_stamp => '120000',
        path       => 'css/custom.css',
    );

    isa_ok( $css, 'ICB::Static::CSS' );
}

done_testing();
