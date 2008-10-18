package Business::Validation::Rule::Accessor;

use strict;
use warnings;
use base qw(Business::Validation::Rule Class::Accessor);
use Carp;
__PACKAGE__->follow_best_practice(); # Creates get_ and set_ accessors.

sub new {
    my ($class, $arg_ref) = @_;

    # If we got a param, but it wasn't a reference or wasn't a hashref,
    # croak.
    croak 'expected hashref as only param to new()'
        if defined $arg_ref and ( not ref $arg_ref or ref $arg_ref ne 'HASH' );
    
    $arg_ref 
        = ( ref $arg_ref and ref $arg_ref eq 'HASH' ) 
        ? $arg_ref 
        : {};


    my $self = $class->SUPER::new();

    for my $key ( keys %$arg_ref ) {
        $self->{$key} = $arg_ref->{$key};      
    }

    $self->mk_accessors(keys %$self);
    return $self;
}

1;

=pod

=head1 NAME

Business::Validation::Rule::Accessor

=head1 DESCRIPTION

A Business::Validation::Rule subclass whose new() method accepts a hashref of accessor names as keys and values to return as their values. The accessors will automatically be created in the rule. Be sure not to override methods that already exist with this, like new, validate, etc... 

This is an abstract class and is meant to be overriden.

=head1 SYNOPSIS

 my $rule = Business::Validation::Rule::Accessor->new({ 
     field1 => 'some_field', 
     field2 => 'diff_field' 
 });

 # somewhere in a subclass
 sub validate() {
     if (     $context->( $self->get_field1() ) eq 'that_value' 
          and $context->( $self->get_field2() ) eq 'other_value' ) 
     {
         return 1;
     }
     return;
 }

=cut
