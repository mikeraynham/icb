use strict;
use warnings;

use Test::More;

use ICB::Static::CSS;

{
    my $css = ICB::Static::CSS->new(
        base       => 'css',
        date_stamp => '20120101',
        time_stamp => '120000',
        path       => 'custom.css',
    );

    isa_ok( $css->minifier, 'CODE' );

    ok( $css->handles_content_type( 'text/css' ),
        'ICB::Static::CSS handles text/css'
    );
}

done_testing();
