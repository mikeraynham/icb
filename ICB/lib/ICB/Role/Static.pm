package ICB::Role::Static;

use strict;
use warnings;

use Carp;
use Path::Class qw/ dir file /;
use Fcntl 'O_RDONLY';
use Tie::File;

use Moose::Role;
use MooseX::Types::Path::Class;

requires qw/
    _content_type
/;

has minifier    => (
    is          => 'ro',
    lazy_build  => 1,
    traits      => ['Code'],
    handles     => { minify  => 'execute' },
);

has base        => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);

has date_stamp  => (
    is          => 'ro',
    isa         => 'Int',
    required    => 1,
);

has time_stamp  => (
    is          => 'ro',
    isa         => 'Int',
    required    => 1,
);

has path        => (
    is          => 'ro',
    isa         => 'Path::Class::File',
    required    => 1,
    coerce      => 1,
);

has combine_dir => (
    is          => 'ro',
    isa         => 'Path::Class::Dir',
    lazy_build  => 1,
    coerce      => 1,
);

has static_dir  => (
    is          => 'ro',
    isa         => 'Path::Class::Dir',
    lazy_build  => 1,
    coerce      => 1,
);

has output_file => (
    is          => 'ro',
    isa         => 'Path::Class::File',
    lazy_build  => 1,
    init_arg    => undef,
);

has _list_file  => (
    is          => 'ro',
    isa         => 'Path::Class::File',
    lazy_build  => 1,
);

sub _build_combine_dir {
    # TODO
    # Get from config and pass to constructor.
    return '/srv/www/catalyst/icb/ICB/root/combine/';
}

sub _build_static_dir {
    # TODO
    # Get from config and pass to constructor.
    return '/srv/www/catalyst/icb/ICB/root/static/';
}

sub _build_output_file {
    my $self = shift;
    my $dir  = dir(
        $self->static_dir,
        $self->base,
        $self->date_stamp,
        $self->time_stamp,
    );

    $dir->mkpath( undef, '0755' );
    
    carp "Cannot create '$dir'"
        unless -d $dir;

    return $dir->file( $self->path ); 
}

sub _build__list_file {
    my $self = shift;

    return file(
        $self->combine_dir,
        $self->base,
        $self->path . '.list'
    );
}

sub handles_content_type {
    my $self         = shift;
    my $content_type = shift;
    return $self->_content_type eq $content_type;
}

sub combine_and_create {
    my $self     = shift;
    my $combined = $self->_process_files();
    my $fh       = $self->output_file->openw();

    print $fh $combined;
    close $fh;
}

sub _file_list {
    my $self = shift;
    my @file_list;

    tie @file_list,
        'Tie::File',
        $self->_list_file->stringify,
        mode => O_RDONLY;

    return \@file_list;
}

sub _process_files {
    my $self  = shift;
    my @files = @{ $self->_file_list };

    my $combined;

    foreach ( @files ) {
        my $content = file( $self->combine_dir, $self->base, $_ )->slurp;
        $content    = $self->process( $content ) if $self->can( 'process' );
        $content    = $self->minify( $content );
        $combined  .= "$content\n";
    }

    return $combined;
}

1;
