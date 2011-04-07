package SPPM::WorkShop::Controller::Inscricao;

use Moose;
use namespace::autoclean;
use Email::Valid;
use String::Random;
use Business::BR::CPF;
use PagSeguro;
use PagSeguro::Item;

BEGIN { extends 'Catalyst::Controller'; }

sub base : Chained('/base') : PathPart('inscricao') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{inscricoes} = $c->model('DB::Inscricao');
}

sub captcha : Local {
    my ( $self, $c ) = @_;
    $c->create_captcha();
}

sub object : Chained('base') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $rs = $c->stash->{inscricoes};

    my $params = $c->req->body_parameters;
    delete $params->{captcha};
    delete $params->{cupom};
		$c->stash->{inscricao} = $rs->new($params);
}

sub inscricao : Chained('object') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    my $params = $c->req->body_parameters;

    return unless $c->req->method eq 'POST';

    $c->stash->{mensagem}{nome} = q{*};
    $c->stash->{erro}{nome}     = q{Favor fornecer o nome completo}
      unless $params->{nome};

    $c->stash->{mensagem}{email} = q{*};
    $c->stash->{erro}{email}     = q{Favor fornecer um email}
      unless Email::Valid->address( $params->{email} );

    $c->stash->{erro}{captcha} = q{Captcha não confere}
      unless $c->validate_captcha( $c->req->param('captcha') );

		my $cupom = $c->model('DB::Cupom')
			->find({ value => $c->req->param('cupom') });
			
		if ( $c->req->param('cupom') ) {
				$c->stash->{erro}{cupom} = q{Cupom não confere}
					if ! $cupom or $cupom->id_inscricao;
		}

    return if %{ $c->stash->{erro} || {} };

    return unless $c->req->method eq 'POST';

		$c->stash->{inscricao}->insert;
		$cupom->update( { id_inscricao => $c->stash->{inscricao}->id } ) if $cupom;
    $c->forward('gerar_codigo');

    #$c->stash(
    #    email_to      => $params->{email},
    #    email_subject => 'Inscrição',
    #    email_content => $c->model('Email')->template(
    #        'inscricao', $params->{nome}, $c->stash->{inscricao}->codigo
    #    ),
    #    sms_to      => $params->{celular},
    #    sms_content => "Seu codigo de ativacao: "
    #      . $c->stash->{inscricao}->codigo,
    #);

    #$c->forward('View::SMS');
    #$c->forward('View::Email');

    $c->res->redirect(
        $c->uri_for(
            $self->action_for('confirmar'),
            $c->stash->{inscricao}->id
        )
    );
}

sub confirmar : Chained('base') Args(1) {
    my ( $self, $c, $id ) = @_;

    #    return unless $c->req->method eq 'POST';
    my $rs       = $c->stash->{inscricoes};
    my $inscrito = $rs->find($id);

    #    $c->stash->{erro}{codigo} = q{Código errado}
    #      unless uc( $c->req->param('codigo') ) eq $inscrito->codigo;

    #    return if %{ $c->stash->{erro} || {} };

    $inscrito->update( { confirmado => 1 } );
	
    $c->res->redirect(
        $c->uri_for( $self->action_for('pagamento'), $inscrito->codigo ) );
}

sub pagamento : Chained('base') Args(1) {
    my ( $self, $c, $codigo ) = @_;
    my $rs       = $c->model('DB::Inscricao');
		my $rs_cupom = $c->model('DB::Cupom');

    my $inscrito = $c->stash->{inscrito} =
      $rs->search( { codigo => $codigo, confirmado => 1 } )->first;
	  my $cupom    = $rs_cupom->find({ id_inscricao => $inscrito->id });

    $c->stash->{erro}{codigo} = q{Pagamento inválido}
      unless $inscrito;

    return if %{ $c->stash->{erro} || {} };

    my $pagseguro = PagSeguro->new(
        email_cobranca => 'shonorio@gmail.com',
        tipo           => 'CP',
        cliente_nome   => $inscrito->nome,
        cliente_email  => $inscrito->email
    );

		# hard coding, 200 mangos é o valor default.
	  my $preco = $cupom ? 200 - $cupom->desconto : 200;

	$c->stash->{preco} = $preco;
	
    $pagseguro->add_items(
        PagSeguro::Item->new(
            id    => $inscrito->id,
            descr => "Perl Workshop SPPM 2011",
            quant => 1,
            valor => $preco * 100,
            frete => 0,
            peso  => 0
        )
    );

    $c->stash->{form} = $pagseguro->make_form;
}

sub gerar_codigo : Private {
    my ( $self, $c ) = @_;

    my $rs = $c->model('DB::Inscricao');
    my $sr = new String::Random;
    my $codigo;

    while (1) {
        $codigo = $sr->randregex('[A-Z0-9]{6}');
        last unless $rs->search( { codigo => $codigo } )->count;
    }

    $c->stash->{inscricao}->update( { codigo => $codigo } );
}

__PACKAGE__->meta->make_immutable;

1;
