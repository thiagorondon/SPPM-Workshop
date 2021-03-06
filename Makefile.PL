#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst;    # Complain loudly if you don't have
                                  # Catalyst::Devel installed or haven't said
                                  # 'make dist' to create a standalone tarball.

name 'SPPM-WorkShop';
all_from 'lib/SPPM/WorkShop.pm';

requires 'Catalyst::Runtime' => '5.80030';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Captcha';
requires 'Catalyst::Action::RenderView';
requires 'Email::Valid';
requires 'String::Random';
requires 'PagSeguro';
requires 'Moose';
requires 'Business::BR::CPF';
requires 'MooseX::Types::CPF';
requires 'MooseX::Types::Email';
requires 'namespace::autoclean';
requires 'Net::SMTP::SSL';
requires 'Authen::SASL';
requires
  'Config::General';  # This should reflect the config file format you've chosen
                      # See Catalyst::Plugin::ConfigLoader for supported formats

requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::View::JSON';
requires 'SQL::Translator' => '0.11006';
requires 'MooseX::NonMoose';

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
