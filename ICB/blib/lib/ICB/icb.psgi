use strict;
use warnings;

use ICB;

my $app = ICB->apply_default_middlewares(ICB->psgi_app);
$app;

