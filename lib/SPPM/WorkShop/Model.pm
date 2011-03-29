
package SPPM::WorkShop::Model;

use Moose;
with 'Catalyst::Component::InstancePerContext';

has 'log' => ( is => 'rw' );

sub build_per_context_instance {
    my ( $self, $c ) = @_;
    $self->new( log => $c->log );
}

1;

