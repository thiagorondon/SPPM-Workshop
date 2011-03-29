
package SPPM::WorkShop::View::SMS;

use Moose;
extends 'Catalyst::View';

use NSMS::API;

has username => (
	is	=> 'rw',
	isa => 'Str',
);

has password => (
	is => 'rw',
	isa => 'Str'
);

sub process {
    my ( $self, $c ) = @_;
    my $to      = $c->stash->{sms_to};
    my $content = $c->stash->{sms_content};
	$to =~ s/[\(\)\-]//g;
	chomp($to);
	$content = 'Sao Paulo Perl Workshop: ' . $content;

	return unless $to =~ /^[0-9]{10}$/;

	my $sms = NSMS::API->new(
		username => $self->username,
		password => $self->password
	);

	$sms->send($to, $content);

}

1;

