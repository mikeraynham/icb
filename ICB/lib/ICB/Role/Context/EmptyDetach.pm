package ICB::Role::Context::EmptyDetach;

use strict;
use warnings;
use namespace::autoclean;

use Moose::Role;

sub empty_detach {
    my $self   = shift;
    my $status = shift;

    $self->response->status( $status ) if $status;
    $self->response->body('');
    $self->detach();
}

1;
