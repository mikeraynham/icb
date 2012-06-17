package ICB::Controller::Menu;
use Moose;
use namespace::autoclean;

use CatalystX::Routes;
            
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ICB::Controller::Menu - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

get '/menu'
    => sub {
    my $self = shift;
    my $c    = shift;

    $c->stash( template => 'menu.tx' );
};

=head1 AUTHOR

Mike Raynham,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
