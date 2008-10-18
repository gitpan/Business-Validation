#! /usr/bin/perl

use lib '/stocksfs/projects/bizr/lib';
use strict;
use warnings;

Business::Validation::TestClass::Result->runtests();
##############################################################################
package Business::Validation::TestClass::Result;

use base 'Test::Class';
use Test::More;
use Test::Deep;
use Test::Exception;
use Data::Dumper;

sub result {
    my ($self) = @_;
    return $self->{result};
}

sub startup : Test(startup => 1) {
    my ($self) = @_;
    use_ok('Business::Validation::Result');
    return;
}

sub setup : Test(setup => 1) {
    my ($self, $arg_ref) = @_;

    $arg_ref = $arg_ref || {
        failed_rules     => {'someparam'  => ['SomeRule']},
        failure_messages => {'someparam' => ['some message']},
        failed_params    => {'SomeRule' => ['someparam']},
    };

    $self->{result} = Business::Validation::Result->new($arg_ref);

    isa_ok( $self->{result}, 'Business::Validation::Result' );

    return;
}

sub get_status : Test(9) {
    my $self = shift;

    ok( !$self->result()->get_status(), 
        'False because there are failed entities' );

    $self->setup({
        failed_rules     => undef,
        failure_messages => undef,
        failed_params    => undef,
    });

    ok( $self->result()->get_status(),
        'True because there are no failed entities' );

    $self->setup({
        failed_rules     => {'SomeRule' => ['someparam']},
        failure_messages => undef,
        failed_params    => undef,
    });

    ok( !$self->result()->get_status(), 
        'False because there are failed entities' );

    $self->setup({
        failed_rules     => undef,
        failure_messages => {'someparam' => ['some message']},
        failed_params    => undef,
    });

    ok( $self->result()->get_status(), 
        'True because there are no failed params/business rules, only msgs' );

    $self->setup({
        failed_rules     => undef,
        failure_messages => undef,
        failed_params    => {'someparam' => ['SomeRule']},
    });

    ok( !$self->result()->get_status(), 
        'False because there are failed entities' );

    return;
}

sub get_failed_rules : Test(1) {
    my $self = shift;

    is_deeply( $self->result()->get_failed_rules(),
        {'someparam' => ['SomeRule']},
        'Got expected failed rules' );

    return;
}

sub get_failed_params : Test(1) {
    my $self = shift;

    is_deeply( $self->result()->get_failed_params(),
        {'SomeRule' => ['someparam']},
        'Got expected failed params' );

    return;
}

sub absorb_result : Test(1) {
    my ($self) = @_;

    my $new_result = Business::Validation::Result->new({
        failed_rules     => {'diffparam'  => ['DiffRule']},
        failure_messages => {'diffparam' => ['some message']},
        failed_params    => {'diffparam' => ['some message']},
    });

    $self->result()->absorb_result($new_result);

    my $expected_rules = {
        'someparam' => ['SomeRule'],
        'diffparam' => ['DiffRule'],
    };

    is_deeply( $self->result()->get_failed_rules(), $expected_rules,
        'Got correct failed_rules after absorb' );

    return;
}
