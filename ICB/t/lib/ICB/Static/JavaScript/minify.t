use strict;
use warnings;

use Test::More;
use Try::Tiny;
use Path::Class qw/ file dir /;
use File::Temp;

use ICB::Static::JavaScript;

# This is the directory containing this test.
my $combine_dir = file( __FILE__)->dir->absolute;

# Create a temporary directory in which to output the combined file.
my $static_dir = dir( File::Temp->newdir() );

my $js = ICB::Static::JavaScript->new(
    base        => 'js',
    date        => '20120601',
    time        => '120000',
    path        => 'icb.js',
    combine_dir => $combine_dir,
    static_dir  => $static_dir,
);

is( $js->_list_file,
    $combine_dir->file( $js->base, $js->path . ".list" ),
    '_list_file correct'
);

ok( $js->handles_type({
        content_type => 'text/javascript',
    }),
    'ICB::Static::JavaScript handles text/javascript'
);

ok( $js->handles_type({
        file_type => 'js',
    }),
    'ICB::Static::JavaScript handles .js files'
);

is_deeply(
    $js->_file_list,
    [ qw/ bootstrap.js / ],
    '_file_list correct'
);

my $output_file = $static_dir->file(
    $js->base,
    $js->date,
    $js->time,
    $js->path
);

is( $js->output_file,
    $output_file,
    'output_file correct'
);
 
subtest 'Combine and create' => sub {
    $js->combine_and_create();

    like( $output_file->slurp(),
        qr/var test=\(function\(\){var this='that';}/s,
        'output file content correct'
    );
};

done_testing();
