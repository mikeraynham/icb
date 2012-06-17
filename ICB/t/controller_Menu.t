use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ICB';
use ICB::Controller::Menu;

ok( request('/menu')->is_success, 'Request should succeed' );
done_testing();
