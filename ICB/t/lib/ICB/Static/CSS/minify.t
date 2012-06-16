use strict;
use warnings;

use Test::More;
use Try::Tiny;
use Path::Class qw/ file dir /;
use File::Temp;

use ICB::Static::CSS;

# This is the directory containing this test.
my $combine_dir = file( __FILE__)->dir->absolute;

# Create a temporary directory in which to output the combined file.
my $static_dir = dir( File::Temp->newdir() );

my $css = ICB::Static::CSS->new(
    base        => 'css',
    date        => '20120601',
    time        => '120000',
    path        => 'icb.css',
    combine_dir => $combine_dir,
    static_dir  => $static_dir,
);

is( $css->_list_file,
    $combine_dir->file( $css->base, $css->path . ".list" ),
    '_list_file correct'
);

ok( $css->handles_type({
        content_type => 'text/css',
    }),
    'ICB::Static::CSS handles text/css'
);

ok( $css->handles_type({
        file_type => 'css',
    }),
    'ICB::Static::CSS handles .css file type'
);

is_deeply(
    $css->_file_list,
    [ qw/ bootstrap.css icb.less / ],
    '_file_list correct'
);

my $output_file = $static_dir->file(
    $css->base,
    $css->date,
    $css->time,
    $css->path
);

is( $css->output_file,
    $output_file,
    'output_file correct'
);
 
subtest 'Combine and create' => sub {
    try { $css->lessc_bin } catch { 
        plan skip_all => 'lessc binary not installed';
    };

    $css->combine_and_create();

    like( $output_file->slurp(),
        qr/font-size.*line-height.*background:/s,
        'output file content correct'
    );
};

done_testing();
