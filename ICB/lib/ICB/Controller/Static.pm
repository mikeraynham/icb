package ICB::Controller::Static;
use Moose;
use namespace::autoclean;

use Path::Class qw/ file /;
use ICB::Factory::Static;
use Data::Dumper;
use CatalystX::Routes;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ICB::Controller::Static - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index
Catalyst::Action::REST
=cut

get '/static'
    => sub {
    my $self = shift;
    my $c    = shift;
    my $base = shift;
    my $date = shift;
    my $time = shift;
    my @path = @_;

    $c->empty_detach( 404 ) unless ( $base =~ /^[a-z]+$/ );
    $c->empty_detach( 404 ) unless ( $date =~ /^\d{8}$/  );
    $c->empty_detach( 404 ) unless ( $time =~ /^\d{6}$/  );

    my $content_type = $c->request->preferred_content_type;
    $c->response->content_type( $content_type );

    my $factory = ICB::Factory::Static->new(
        content_type => $content_type,
    );

    my $static = $factory->construct(
        base => $base,
        date => $date,
        time => $time,
        path => @path,
    );

    my $response = $static->combine_and_create;

    $c->response->body( $response // '' );
};

=head1 AUTHOR

Mike Raynham,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
