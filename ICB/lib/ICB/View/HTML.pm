package ICB::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::Xslate';

__PACKAGE__->config(
    template_extension => '.tx',
	cache              => 1,
);

1;

=head1 NAME

ICB::View::HTML - Xslate View for ICB

=head1 DESCRIPTION

Xslate View for ICB.

=cut

