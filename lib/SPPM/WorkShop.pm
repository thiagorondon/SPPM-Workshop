package SPPM::WorkShop;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
  ConfigLoader
  Static::Simple
  Session
  Session::Store::FastMmap
  Session::State::Cookie
  Captcha
  /;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in sppm_workshop.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'SPPM::WorkShop',

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    default_view                                => 'TT',
    default_model                               => 'DB',

    'Plugin::Captcha' => {
        session_name => 'captcha_string',
        new          => {
            width   => 160,
            height  => 60,
            lines   => 5,
            gd_font => 'giant',
        },
        create   => [qw/normal rect/],
        particle => [100],
        out      => { force => 'jpeg' }
    }
);

# Start the application
__PACKAGE__->setup();

sub finalize_error {
    my ($c) = @_;
    if ( scalar @{ $c->error } ) {
        $c->flash->{erro} = join '', @{ $c->error };
        $c->res->redirect( $c->uri_for_action('/error') );
        $c->error(0);
        return 0;
    }
    else {
        return 1;
    }
}

=head1 NAME

SPPM::WorkShop - Catalyst based application

=head1 SYNOPSIS

    script/sppm_workshop_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<SPPM::WorkShop::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Daniel Mantovani,,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
