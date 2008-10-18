package Business::Validation::Rule;

use strict;
use warnings;
use base 'Class::Accessor';
use Carp;

__PACKAGE__->follow_best_practice();

sub new {
    my ($class) = @_;
    $class = ( ref $class ) ? ref $class : $class;
    my $self = { messages => {} };

    __PACKAGE__->mk_ro_accessors('messages');
    
    return bless $self, ref $class || $class;
}

sub validate {
    croak 'Subclass must override validate() method';
}

sub set_message {
    my ( $self, $arg_ref ) = @_;

    for my $param ( qw(message param) ) {
        croak "Missing requied named param: '$param'" 
            if not defined $arg_ref->{$param};
    }

    push @{$self->{messages}{ $arg_ref->{param} }}, $arg_ref->{message};
}

1;

=pod

=head1 NAME

Business::Validation::Rule

=head1 DESCRIPTION

Abstract base class for business rules.

=head1 METHODS

=head2 new()

    Create a new Business::Validation::Rule object. 

=head2 validate()

    Execute the code that will validate the rule on the data. Subclasses 
    must override this method with code that will validate the input. 
    This method will be passed the context as the only named param:

        context => the Business::Validation::Context object.

    This method should return a true value for success and a false value
    for failure.

=head2 get_messages()

    Get the message for this rule. 

=head2 set_messages()

    Pass in a hashref of context_param_name => error_message. This will
    clobber all messages that have previously been set. Use the set_message()
    method to set one at a time.

=head2 set_message()

    Pass in a hashref containg:

        param   => name of the context param
        message => message to associate with the param

    This method appends to already existing messages unlike set_messages().

=cut
