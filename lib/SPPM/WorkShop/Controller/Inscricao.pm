package SPPM::WorkShop::Controller::Inscricao;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub base : Chained('/base') : PathPart('inscricao') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{inscricoes} = $c->model('DB::Inscricao');
}

sub object :Chained('base') PathPart('') CaptureArgs(0) {
    my($self, $c) = @_;
    my $rs = $c->stash->{inscricoes};
    my $obj = $c->stash->{inscricao} = $rs->find_or_new($c->req->body_parameters);
}

sub inscricao : Chained('object') PathPart('') Args(0) {
    my($self, $c) = @_;
    my $params = $c->req->body_parameters;

    $c->stash->{mensagem}{nome} = q{*};
    $c->stash->{erro}{nome} = q{Favor fornecer o nome completo}
        unless $params->{nome};

    $c->stash->{mensagem}{email} = q{*};
    $c->stash->{erro}{email} = q{Favor fornecer um email}
        unless $params->{email};

    $c->stash->{mensagem}{celular} = q{*};
    $c->stash->{erro}{celular} = q{Favor fornecer o celular}
        unless $params->{celular};

    return if %{$c->stash->{erro} || {}};
    $c->stash->{inscricao}->insert if $c->req->method eq 'POST';
}

__PACKAGE__->meta->make_immutable;

1;
