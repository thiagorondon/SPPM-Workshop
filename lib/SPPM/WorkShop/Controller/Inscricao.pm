package SPPM::WorkShop::Controller::Inscricao;

use Moose;
use namespace::autoclean;
use Email::Valid;
use String::Random;

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
    my $obj = $c->stash->{inscricao} = $rs->find_or_new($params);
}

sub inscricao : Chained('object') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    my $params = $c->req->body_parameters;

    $c->stash->{mensagem}{nome} = q{*};
    $c->stash->{erro}{nome}     = q{Favor fornecer o nome completo}
      unless $params->{nome};

    $c->stash->{mensagem}{email} = q{*};
    $c->stash->{erro}{email}     = q{Favor fornecer um email}
      unless Email::Valid->address( $params->{email} );

    $c->stash->{mensagem}{celular} = q{*};
    $c->stash->{erro}{celular}     = q{Favor fornecer o celular}
      unless $params->{celular};

    $c->stash->{mensagem}{cpf} = q{*};
    $c->stash->{erro}{cpf}     = q{Favor fornecer o cpf}
      unless $params->{cpf};

    return if %{ $c->stash->{erro} || {} };

    return unless $c->req->method eq 'POST';

    $c->stash->{erro}{captcha} = q{Captcha não confere}
      unless $c->req->address eq '127.0.0.1'
          and $c->validate_captcha( $c->req->param('captcha') );

    $c->stash->{inscricao}->insert;
    $c->forward('gerar_codigo');

    $c->res->redirect(
        $c->uri_for(
            $self->action_for('confirmar'),
            $c->stash->{inscricao}->id
        )
    );
}

sub confirmar : Chained('base') Args(1) {
    my ( $self, $c, $id ) = @_;

    return unless $c->req->method eq 'POST';
    my $rs       = $c->stash->{inscricoes};
    my $inscrito = $rs->find($id);

    $c->stash->{erro}{codigo} = q{Código errado}
      unless uc($c->req->param('codigo')) eq $inscrito->codigo;

    return if %{ $c->stash->{erro} || {} };

    $inscrito->update( { confirmado => 1 } );

    $c->res->redirect(
        $c->uri_for( $self->action_for('pagamento'), $inscrito->codigo ) );
}

sub pagamento : Chained('base') Args(1) {
    my ( $self, $c, $codigo ) = @_;
    my $rs = $c->model('DB::Inscricao');
    $c->stash->{inscrito} = $rs->search({ codigo => $codigo })->first;
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
