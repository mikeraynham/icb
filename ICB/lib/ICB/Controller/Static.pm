package ICB::Controller::Static;
use Moose;
use namespace::autoclean;

use Path::Class qw/ file /;

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

chain_point '_static'
    => chained '/'
    => path_part 'static'
    => capture_args 0
    => sub {
    my $self = shift;
    my $c    = shift;
    
    $c->stash( content_type => $c->request->preferred_content_type );
    $c->response->content_type( $c->stash->{content_type} );
};

chain_point '_base'
    => chained '_static'
    => path_part ''
    => capture_args 1
    => sub {
    my $self = shift;
    my $c    = shift;
    my $base = shift;

    $c->log->debug( "_base: $base" );

    $c->empty_detach( 404 )
        unless ( $base =~ /^[a-z]+$/ );

    $c->stash( base => $base );
};

chain_point '_date'
    => chained '_base'
    => path_part ''
    => capture_args 1
    => sub {
    my $self = shift;
    my $c    = shift;
    my $date = shift;

    $c->log->debug( "_date: $date" );

    $c->empty_detach( 404 )
        unless ( $date =~ /^\d{8}$/ );

    $c->stash( date => $date );
};

chain_point '_time'
    => chained '_date'
    => path_part ''
    => capture_args 1
    => sub {
    my $self = shift;
    my $c    = shift;
    my $time = shift;

    $c->log->debug( "_time: $time" );

    $c->empty_detach( 404 )
        unless ( $time =~ /^\d{6}$/ );
        
    $c->stash( time => $time );
};

get 'path'
    => chained '_time'
    => path_part ''
    => sub {
    my $self = shift;
    my $c    = shift;
    my $file = file(
        $c->stash->{base},
        $c->stash->{date},
        $c->stash->{time},
        @_
    );

    $c->log->debug( '_path' );

    $c->log->debug( $c->stash->{content_type} );
    $c->log->debug( $file );
    $c->response->body( $file );
};

=head1 AUTHOR

Mike Raynham,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
