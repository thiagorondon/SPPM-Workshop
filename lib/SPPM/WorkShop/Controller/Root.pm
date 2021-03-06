package SPPM::WorkShop::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config( namespace => '' );

=head1 NAME

SPPM::WorkShop::Controller::Root - Root Controller for SPPM::WorkShop

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 default

Standard 404 error page

=cut

sub base : Chained('/') PathPart('') CaptureArgs(0) {}

sub root : Chained('/base') PathPart('') Args(0) {}

sub programacao : Chained('/base') Args(0) {}

sub local : Chained('/base') Args(0) {}

sub palestrantes : Chained('/base')  Args(0) {}

sub evento : Chained('/base') Args(0) {}

sub faq : Chained('/base') Args(0) {}

sub divulgue : Chained('base') Args(0) {}

sub error : Chained('base') : PathPart {
}

sub error_404 :Chained('base') PathPart('') Args {
    my ( $self, $c ) = @_;
    $c->response->body('Page not found');
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Daniel Mantovani,,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
