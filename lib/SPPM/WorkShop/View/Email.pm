
package SPPM::WorkShop::View::Email;

use Moose;
extends 'Catalyst::View';

use Email::Valid;
use Net::SMTP::SSL;

has login => (
	is => 'rw',
	isa => 'Str'
);

has password => (
	is => 'rw',
	isa => 'Str'
);

sub process {
    my ( $self, $c ) = @_;

    my $from     = $self->login;
    my $password = $self->password;
    my $to       = $c->stash->{email_to};
    my $subject  = $c->stash->{email_subject};
    my $content  = $c->stash->{email_content};

    my $smtp = new Net::SMTP::SSL( 'smtp.gmail.com', Port => 465, );

    $smtp->auth( $from, $password );
    $smtp->mail($from);
    $smtp->to($to);

    $smtp->data();
    $smtp->datasend("To:  $to\n");
    $smtp->datasend("From:  $from\n");
    $smtp->datasend("Subject: II São Paulo Perl Workshop: $subject\n");
    $smtp->datasend("MIME-Version: 1.0\n");
    $smtp->datasend("Content-type: text/plain\n");
    $smtp->datasend("Content-Transfer-Encoding: 7bit\n");
    $smtp->datasend("\n");
    $smtp->datasend( $content . "\n\n" );
    $smtp->dataend();

    $smtp->quit;
}

1;

