
package SPPM::WorkShop::Schema::Result::Cupom;

use Moose;
extends 'DBIx::Class::Core';

__PACKAGE__->table("cupom");

__PACKAGE__->add_columns(
	"value",
	{ data_type => "text", is_nullable => 0 },
	"id_inscricao",
	{ data_type => "integer", is_nullable => 1 }
);

__PACKAGE__->set_primary_key("value");
__PACKAGE__->add_unique_constraint([qw/id_inscricao/]);
1;
