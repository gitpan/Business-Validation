package Business::Validation::Result;

use strict;
use warnings;
use base 'Class::Accessor';
use Carp;
use Params::Validate;

__PACKAGE__->follow_best_practice(); # Create get_ and set_ accessors.

sub new { 
    my $class = shift;
    my ($arg_ref) = @_;

    Params::Validate::validate(@_, { 
        failed_rules     => 1,
        failure_messages => 1,
        failed_params    => 1,
    });

    # Create object and accessors.
    my %self = %$arg_ref;
    $class = ( ref $class ) ? ref $class : $class;
    $class->mk_ro_accessors(keys %self);
    my $self = bless \%self, $class;

    $self->_calculate_status();

    return $self;
}

sub _calculate_status {
    my ($self) = @_;

    # Calculate
    if (     not $self->get_failed_rules()
         and not $self->get_failed_params() )
    {

        # All rules and fields succeeded.
        $self->{status} = 1;
    }
    else {

        # Something failed.
        $self->{status} = undef;
    }


    # Create accessor if not already created.
    $self->mk_ro_accessors('status') if not $self->can('get_status');
    return;
}

sub absorb_result {
    my ($self, $result) = @_;

    # Add the failed rules and params to the object.
    for my $entity (qw( rules params )) {
        my $get_failed_method = "get_failed_$entity";
        for my $param ( keys %{$result->$get_failed_method()} ) {
            push @{$self->{"failed_$entity"}{$param}}, 
                @{$result->$get_failed_method()->{$param}};
        }
    }

    # Add the failure messages to the object.
    for my $param ( keys %{$result->get_failure_messages()} ) {
        push @{$self->{failure_messages}{$param}}, 
            $result->get_failure_messages()->{$param};
    }

    return;
}

1;

=pod

=head1 NAME

Business::Validation::Results

=head1 DESCRIPTION

Business rules results object. The results from processing the given rules
with the given context.

=head1 METHODS

=head2 new()

Creates a new Business::Validation::Result object. Takes a hashref with the following keys:

  failed_rules    => { '$RulePackageName' => [ '$context_parm'   ] },
  failed_messages => { '$context_param'   => [ '$failure_message' ] },
  failed_params   => { '$context_param'   => [ '$RulePackageName' ] },

=head2 get_status()

Returns true or false as to whether the context successfully validated
against the rules.

=head2 get_failed_rules()

Returns a hashref of all the rules that failed and the context params that they 
failed for. Rule package names are the keys. The values are an arrayref of context param names.

=head2 get_failed_params()

Returns a hashref with all the failed params as keys and an arrayref of failed rules as values.

=head2 get_failure_messages()

Returns a hashref of all failed context params as keys and an arrayref of all the failure messages as values.

=head2 absorb_result()

Takes a Business::Validation::Result object as the only parameter. Absorbs all the information from the passed in Business::Validation::Result object into this Business::Validation::Result object.

=cut
