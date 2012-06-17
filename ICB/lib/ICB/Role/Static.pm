package ICB::Role::Static;

use strict;
use warnings;

use Carp;
use Path::Class qw/ dir file /;
use Fcntl 'O_RDONLY';
use Tie::File;
use File::Temp;

use Moose::Role;
use MooseX::Types::Path::Class;

requires qw/
    content_type
    file_type
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

has date        => (
    is          => 'ro',
    isa         => 'Int',
    required    => 1,
);

has time        => (
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
        $self->date,
        $self->time,
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

sub _file_list {
    my $self      = shift;
    my $list_file = $self->_list_file->stringify;
    my @file_list;

    carp "No list file found at '$list_file'"
        unless -f $list_file;

    tie @file_list,
        'Tie::File',
        $list_file,
        mode => O_RDONLY;

    carp "No files found in '$list_file'"
        unless @file_list;

    return \@file_list;
}

sub _combine_files {
    my $self  = shift;
    my @files = @{ $self->_file_list };
    my $combined;

    foreach ( @files ) {
        s/#.*//;
        next if /^\s*$/;

        my $file = file( $self->combine_dir, $self->base, $_ );
        carp( "'$file' does not exist" ), next unless -f $file;

        if ( $self->can( '_process_file' ) ) {
            $combined .= $self->_process_file( $file );
        } else {
            $combined .=  $file->slurp();
        }
    }

    return $combined;
}

sub handles_type {
    my $self = shift;
    my $type = shift;

    return 1 if $self->content_type eq ($type->{content_type} || '');
    return 1 if $self->file_type    eq ($type->{file_type}    || '');
}

sub combine_and_create {
    my $self = shift;

    # Stitch the files together first.
    return unless my $combined = $self->_combine_files();

    # Minify the combined and processed result.
    return unless $combined = $self->minify( $combined );

    # Write the final result to the static file.
    my $fh = $self->output_file->openw();

    print $fh $combined;
    close $fh;

    return $combined;
}

1;
