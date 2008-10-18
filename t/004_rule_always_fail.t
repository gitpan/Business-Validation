#! /usr/bin/perl

use lib '/stocksfs/projects/bizr/lib';
use strict;
use warnings;

Business::Validation::TestClass::Rule::AlwaysFail->runtests();
##############################################################################
package Business::Validation::TestClass::Rule::AlwaysFail;

use base 'Test::Class';
use Test::More;
use Test::Exception;
use Test::Deep;
use Data::Dumper;

sub rule {
    my ($self) = @_;
    return $self->{rule};
}

sub startup : Test(startup => 2) {
    my ($self) = @_;
    use_ok('Business::Validation::Rule::AlwaysFail');
    use_ok('Business::Validation::Context');
    return;
}

sub setup : Test(setup => 1) {
    my ($self) = @_;
    $self->{rule} = Business::Validation::Rule::AlwaysFail->new();
    isa_ok( $self->{rule}, 'Business::Validation::Rule::AlwaysFail' );
    return;
}

sub validate : Test(1) {
    my ($self) = @_;

    ok( !$self->rule()->validate(), 'validate() always fails' );

    return;
}

sub get_messages : Test(2) {
    my ($self) = @_;

    $self->rule()->validate(Business::Validation::Context->new());
   
    is( $self->rule()->get_messages()->{''}->[0], 'This always fails.',
        'get_messages() returned correct message' );

    my $expected_result = {
        '' => [ 'This always fails.' ],
    };

    is_deeply( $self->rule()->get_messages(), $expected_result,
        'get_messages() returned expected data structure' );   

    return;
}
