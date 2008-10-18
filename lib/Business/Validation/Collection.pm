package Business::Validation::Collection;

use strict;
use warnings;
use base 'Class::Accessor';
use Carp;
use Data::Dumper;
use Business::Validation::Result;

__PACKAGE__->follow_best_practice(); # get_ set_

sub new {
    my ($class, $arg_ref) = @_;

    # Object data.
    my $self = {};
    $self->{rules}       = $arg_ref->{rules}       || [];
    $self->{collections} = $arg_ref->{collections} || [];

    # Validate params
    for my $element (qw{Rule Collection}) {
        map { croak "Not a valid $element" if !$_->isa(lc $element . q{s}) } 
            @{$self->{rules}};
    }

    $class = ( ref $class ) ? ref $class : $class;

    # Create 'results' accessors
    $class->mk_ro_accessors('result');
    return bless $self, $class;
}

sub add_rule {
    my ($self, @rules) = @_;
    push @{$self->{rules}}, @rules;
    # TODO: Probably should return something meaningful here.
}

sub get_rules {
    my ($self) = @_;
    my @rules = @{ $self->{rules} };
    push @rules, map { $_->get_rules() } @{ $self->get_collections() };
    return \@rules;
}

sub add_collection {
    my ($self, @collections) = @_;
    push @{$self->{collections}}, @collections;
    # TODO: Probably should return something meaningful here.
}

sub get_collections {
    my ($self) = @_;

    # Get the collections from the object.
    my @collections = @{ $self->{collections} };

    # Go through each collection and grab the children. I believe this
    # will recurse all the way down the parent children tree.
    push @collections, map { @{$_->get_collections()} } @collections;

    return \@collections;
}

sub validate {
    my ($self, $context) = @_;

    # Perform validation and get all the failed rules, params, and messages.
    my @failed_rules = grep { !$_->validate({ context => $context }) } 
        @{$self->get_rules()};


    # TODO: Optimize these loops.

    # Create hashref of:
    #    RulePackageName => [ 'context_param_name' ]
    my %failed_params_for = 
        map { ref $_ => [keys %{$_->get_messages()}] } @failed_rules;

    my @params = values %failed_params_for;


    # Create hashref of:
    #    context_param_name => [ 'RulePackageName' ]
    my %failed_rules_for;
    while ( my ($rule, $params_ref) = each %failed_rules_for ) {
        for my $param ( @$params_ref ) {
            push @{$failed_rules_for{$param}}, $rule;
        }
    }

    
    # Create hashref of:
    #    context_param_name => [ 'failure_message' ]
    my %failure_messages_for;
    for my $rule ( @failed_rules ) {
        while ( my ( $param, $messages_ref ) = each %{$rule->get_messages()} )
        {
            push @{$failure_messages_for{$param}}, @{$messages_ref};
        }
    }


    # Create a Business::Validation::Result object and populate it with 
    # all the results data.
    my $result = Business::Validation::Result->new({
        failed_params    => \%failed_params_for,
        failed_rules     => \%failed_rules_for,
        failure_messages => \%failure_messages_for,
    });

    #return ( grep { !$_->validate() } @{$self->get_rules()} ) ? 0 : 1;
    return $result;
}

1;

=pod

=head1 NAME

Business::Validation::Collection

=head1 DESCRIPTION

A collection is a bundle of rules which you eventually pass to a Business::Validation::Engine along with a Business::Validation::Context.

=head1 METHODS

=head2 new()

    Create a new collection.

=head2 add_rule()

    Add a rule to this collection.

=head2 get_rules()

    Get all the rules in this collection, including those in sub-collections.

=head2 add_collection()

    Add a sub-collection to this collection.

=head2 get_collections()

    Get an array of all the collections this collection contains. Does not
    include this collection.

=head2 validate()

    Takes no parameters.
    Returns false if any of the rules fail and true if all the rules pass.

=cut
