package SPPM::WorkShop::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'SPPM::WorkShop::Schema',
    connect_info => {
        dsn => 'dbi:SQLite:dbname=sppw.db',
        user => '',
        password => '',
    }
);

=head1 NAME

SPPM::WorkShop::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<SPPM::WorkShop>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<SPPM::WorkShop::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.48

=head1 AUTHOR

Eden Cardim

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
