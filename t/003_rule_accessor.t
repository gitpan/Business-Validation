#! /usr/bin/perl

use lib '/stocksfs/projects/bizr/lib';
use strict;
use warnings;

Business::Validation::TestClass::Rule::Accessor->runtests();
##############################################################################
package Business::Validation::TestClass::Rule::Accessor;

use base 'Test::Class';
use Test::More;
use Test::Exception;
use Data::Dumper;

sub rule {
    my ($self) = @_;
    return $self->{rule};
}

sub startup : Test(startup => 4) {
    my ($self) = @_;

    use_ok( 'Business::Validation::Rule::Accessor' );

    my $rule;
    lives_ok { $rule = Business::Validation::Rule::Accessor->new() }
        'Can create an object without any params to new()';

    # Make sure we can call parent class method.
    can_ok( $rule, qw(get_messages) );

    ok( exists $rule->{messages}, 
        'messages key from parent class exists in object' );

    return;
}

sub setup : Test(setup => 1) {
    my ($self) = @_;
    $self->{rule} = Business::Validation::Rule::Accessor->new();
    isa_ok( $self->{rule}, 'Business::Validation::Rule::Accessor' );
    return;
}

# cannot use new()
sub new_test : Test(1) {
    my ($self) = @_;

    my $obj = $self->rule()->new({ test => 'true' });
    
    is( $obj->get_test(), 'true', 
        'Accessor created and correct value returned' );

    return;
}
