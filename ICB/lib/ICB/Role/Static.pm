package ICB::Role::Static;

use strict;
use warnings;

use Path::Class qw/ file /;
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

has _root_dir   => (
    is          => 'ro',
    isa         => 'Path::Class::Dir',
    lazy_build  => 1,
    coerce      => 1,
);

has _list_file  => (
    is          => 'ro',
    isa         => 'Path::Class::File',
    lazy_build  => 1,
);

sub _build__root_dir {
    # TODO
    # Get the root dir from config.
    return '/srv/www/catalyst/icb/ICB/root/combine/';
}

sub _build__list_file {
    my $self = shift;

    return file(
        $self->_root_dir,
        $self->base,
        $self->path . '.list'
    );
}

sub handles_content_type {
    my $self         = shift;
    my $content_type = shift;
    return $self->_content_type eq $content_type;
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

1;
