#! /usr/bin/perl

use lib '/stocksfs/projects/bizr/lib';
use strict;
use warnings;

Business::Validation::TestClass::Engine->runtests();
##############################################################################
package Business::Validation::TestClass::Engine;

use base 'Test::Class';
use Test::More;
use Test::Deep;
use Test::Exception;

sub engine {
    my ($self) = @_;
    return $self->{engine};
}

sub startup : Test(startup => 5) {
    my ($self) = @_;

    my @classes = qw{
        Business::Validation::Engine 
        Business::Validation::Context 
        Business::Validation::Collection 
        Business::Validation::Rule
        Business::Validation::Rule::AlwaysFail
    };

    for my $class ( @classes ) { use_ok($class); }

    return;
}

sub setup : Test(setup => 1) {
    my ($self) = @_;
    $self->{engine} = Business::Validation::Engine->new();
    isa_ok( $self->{engine}, 'Business::Validation::Engine' );
    return;
}

sub validate : Test(2) {
    my ($self) = @_;

    my $context    = Business::Validation::Context->new();
    my $collection = Business::Validation::Collection->new();
    $collection->add_rule( Business::Validation::Rule::AlwaysFail->new() );

    my $success = $self->engine()->validate({
        context    => $context,
        collection => $collection,
    });

    ok( !$success, 'Engine returned failure' );

    isa_ok( $self->engine()->get_results(), 'Business::Validation::Result',
        'get_results() returned a Business::Validation::Results object' );

    return;
}
