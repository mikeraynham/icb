use strict;
use warnings;

use Test::More;

package Foo;

use CSS::Minifier::XS;

use Moose;
with 'ICB::Role::Static';

sub _build_minifier { \&CSS::Minifier::XS::minify }
sub _content_type () { 'text/css' }

package main;

use Path::Class qw/ file dir /;
use File::Temp;

# This is the 'combined' directory in the test directory.
my $combine_dir = file( __FILE__)->dir->subdir( 'combine' )->absolute;

# Create a temporary directory in which to output the combined file.
my $static_dir = dir( File::Temp->newdir() );

my $foo = Foo->new(
    base        => 'css',
    date_stamp  => '20120601',
    time_stamp  => '120000',
    path        => 'icb.css',
    combine_dir => $combine_dir,
    static_dir  => $static_dir,
);

is( $foo->_list_file,
    $combine_dir->file( $foo->base, $foo->path . ".list" ),
    '_list_file correct'
);

ok( $foo->handles_content_type( 'text/css' ),
    'content type handling correct'
);

is_deeply(
    $foo->_file_list,
    [ qw/ bootstrap.css icb.less / ],
    '_file_list correct'
);

my $combined = $foo->_process_files(); 

like(
    $combined,
    qr/font-size.*line-height.*icb-brown/s,
    'Combined content looks correct'
);

my $output_file = $static_dir->file(
    $foo->base,
    $foo->date_stamp,
    $foo->time_stamp,
    $foo->path
);

is( $foo->output_file,
    $output_file,
    'output_file correct'
);
 
$foo->combine_and_create();

is( $output_file->slurp(),
    $combined,
    'output file content correct'
);

done_testing();
