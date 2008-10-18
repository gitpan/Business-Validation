#! /usr/bin/perl

use lib '/stocksfs/projects/bizr/lib';
use strict;
use warnings;

Business::Validation::TestClass::Rule->runtests();
##############################################################################
package Business::Validation::TestClass::Rule;

use base 'Test::Class';
use Test::More;
use Test::Exception;
use Business::Validation::Rule;

sub setup : Test(setup => 1) {
    my ($self) = @_;
    $self->{rule} = Business::Validation::Rule->new();
    isa_ok( $self->{rule}, 'Business::Validation::Rule' );
    return;
}

sub validate : Test(1) {
    my ($self) = @_;

    dies_ok { $self->{rule}->validate() } 
        'validate() dies for abstract base class';   

    return;
}


sub get_message : Test(1) {
    my ($self) = @_;

    dies_ok { $self->{rule}->get_message() } 
        'get_message() dies for abstract base class';   

    return;
}
