#! /usr/bin/perl

use lib '/stocksfs/projects/bizr/lib';
use strict;
use warnings;

Business::Validation::TestClass::Collection->runtests();
##############################################################################
package Business::Validation::TestClass::Collection;

use base 'Test::Class';
use Test::More;
use Test::Exception;
use Business::Validation::Collection;
use Business::Validation::Rule;
use Data::Dumper;

sub collection {
    my ($self) = @_;
    return $self->{collection};
}

sub setup : Test(setup => 1) {
    my ($self) = @_;
    $self->{collection} = Business::Validation::Collection->new();
    isa_ok( $self->{collection}, 'Business::Validation::Collection' );
    return;
}

sub add_rule : Test(2) {
    my ($self) = @_;

    my $rule = Business::Validation::Rule->new();

    $self->collection()->add_rule($rule);

    my @rules = ($rule);

    is_deeply( $self->collection()->get_rules(), \@rules ,
        'Rule added and retrieved successfully' );

    $self->collection()->add_rule($rule);

    push @rules, $rule;

    is_deeply( $self->collection()->get_rules(), \@rules ,
        'Second rule added and retrieved successfully' );

    return;
}

sub get_rules : Test(1) {
    my ($self) = @_;

    my $rule = Business::Validation::Rule->new();

    $self->collection()->add_rule($rule);

    my @rules = ($rule);

    is_deeply( $self->collection()->get_rules(), \@rules ,
        'Rule added and retrieved successfully' );

    return;
}

sub add_collection : Test(3) {
    my ($self) = @_;

    my $collection = Business::Validation::Collection->new();
    $self->collection()->add_collection($collection);

    is( scalar @{$self->collection()->get_collections()}, 1,
        'Only one sub collection in parent collection' );

    my $collection2 = Business::Validation::Collection->new();
    $collection->add_collection($collection2);

    # $collection has one collection.
    is( scalar @{$collection->get_collections()}, 1,
        'Only one sub collection in parent collection' );

    # $self->collection has two collections.
    is( scalar @{$self->collection()->get_collections()}, 2,
        'Two sub collections in parent collection' );

    return;
}

sub get_collections : Test(5) {
    my ($self) = @_;

    my $collection1 = Business::Validation::Collection->new();
    my $collection2 = Business::Validation::Collection->new();
    my $collection3 = Business::Validation::Collection->new();
    my $collection4 = Business::Validation::Collection->new();
    my $collection5 = Business::Validation::Collection->new();

    $collection4->add_collection($collection5);
    $collection3->add_collection($collection4);
    $collection2->add_collection($collection3);
    $collection1->add_collection($collection2);
    $self->collection()->add_collection($collection1);

    is( scalar @{$collection4->get_collections()}, 1,
        '$collection4 has 1 collection' );

    is( scalar @{$collection3->get_collections()}, 2,
        '$collection4 has 2 collection' );

    is( scalar @{$collection2->get_collections()}, 3,
        '$collection4 has 3 collection' );

    is( scalar @{$collection1->get_collections()}, 4,
        '$collection4 has 4 collection' );

    is( scalar @{$self->collection()->get_collections()}, 5,
        'Parent collection has 5 collections' );

    return;
}

sub validate : Test(5) {
    my ($self) = @_;

    use_ok( 'Business::Validation::Rule::AlwaysFail' );

    my $rule = Business::Validation::Rule::AlwaysFail->new();

    $self->collection()->add_rule($rule);

    isa_ok( $self->collection()->validate(), 'Business::Validation::Result' );
    
    my $result = $self->collection()->validate();    

    ok( !$result->get_status(),
        'Collection validation fails because one of the rules fails' );

    ok( exists $result->get_failed_params()->{'Business::Validation::Rule::AlwaysFail'},
        'Found rule package as key in results failed_params' );

    is( $result->get_failed_params()->{'Business::Validation::Rule::AlwaysFail'}->[0],
        q{},
        'No param name for always fail rule.' );
        

    return;
}

