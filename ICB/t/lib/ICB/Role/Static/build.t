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

# This is the 'combined' directory in the test directory.
my $root_dir = file( __FILE__)->dir->subdir( 'combine' )->absolute;

my $foo = Foo->new(
    base       => 'css',
    date_stamp => '20120601',
    time_stamp => '120000',
    path       => 'icb.css',
    _root_dir  => $root_dir,
);

is( $foo->_list_file,
    $root_dir->file( 'icb.css.list'),
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

my $content = $foo->_process_files();
print $content;
print "\n";
done_testing();
