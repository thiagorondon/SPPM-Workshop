package SPPM::WorkShop::Controller::Inscricao;

use Moose;
use namespace::autoclean;

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
    my $rs  = $c->stash->{inscricoes};
    
    my $params = $c->req->body_parameters;
    delete $params->{captcha};
    my $obj = $c->stash->{inscricao} =
      $rs->find_or_new( $params );
}

sub inscricao : Chained('object') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    my $params = $c->req->body_parameters;

    $c->stash->{mensagem}{nome} = q{*};
    $c->stash->{erro}{nome}     = q{Favor fornecer o nome completo}
      unless $params->{nome};

    $c->stash->{mensagem}{email} = q{*};
    $c->stash->{erro}{email}     = q{Favor fornecer um email}
      unless $params->{email};

    $c->stash->{mensagem}{celular} = q{*};
    $c->stash->{erro}{celular}     = q{Favor fornecer o celular}
      unless $params->{celular};

    $c->stash->{mensagem}{cpf} = q{*};
    $c->stash->{erro}{cpf}     = q{Favor fornecer o cpf}
      unless $params->{cpf};

    return if %{ $c->stash->{erro} || {} };

    return unless $c->req->method eq 'POST';
    
    $c->stash->{erro}{captcha} = q{Captcha não confere}
      unless $c->req->address ne '127.0.0.1'
          and $c->validate_captcha( $c->req->param('captcha') );

    $c->stash->{inscricao}->insert;
}

__PACKAGE__->meta->make_immutable;

1;
