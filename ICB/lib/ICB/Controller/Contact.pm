package ICB::Controller::Contact;
use Moose;
use namespace::autoclean;

use CatalystX::Routes;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ICB::Controller::Contact - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

get '/contact'
    => sub {
    my $self = shift;
    my $c    = shift;

    $c->stash( template => 'contact.tx' );
};

=head1 AUTHOR

Mike Raynham,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
