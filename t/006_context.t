#! /usr/bin/perl

use lib '/stocksfs/projects/bizr/lib';
use strict;
use warnings;

Business::Validation::TestClass::Context->runtests();
##############################################################################
package Business::Validation::TestClass::Context;

use base 'Test::Class';
use Test::More;
use Test::Deep;
use Test::Exception;
use Business::Validation::Context;

sub setup : Test(setup => 1) {
    my ($self) = @_;
    $self->{context} = Business::Validation::Context->new();
    isa_ok( $self->{context}, 'Business::Validation::Context' );
    return;
}

sub param : Test(2) {
    my ($self) = @_;

    $self->{context}->param('test', 'something');

    is( $self->{context}->param('test'), 'something', 'Got set param value' );

    my @test = (qw(test something));
    $self->{context}->param('arrayref', @test);

    is( $self->{context}->param('arrayref'), 'test', 
        'Got only first value of array' );

    return;
}
