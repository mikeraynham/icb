use strict;
use warnings;

use Test::More;

use ICB::Factory::Static;

subtest 'CSS' => sub {
    my $factory = ICB::Factory::Static->new(
        content_type => 'text/css',
        file_type    => 'css',
    );

    my $static = $factory->construct(
        base => 'css',
        date => '20120101',
        time => '120000',
        path => 'icb.css',
    );

    isa_ok( $static, 'ICB::Static::CSS' );
};

subtest 'JavaScript' => sub {
    my $factory = ICB::Factory::Static->new(
        content_type => 'text/javascript',
        file_type    => 'js',
    );

    my $static = $factory->construct(
        base => 'js',
        date => '20120101',
        time => '120000',
        path => 'icb.js',
    );

    isa_ok( $static, 'ICB::Static::JavaScript' );
};

done_testing();
