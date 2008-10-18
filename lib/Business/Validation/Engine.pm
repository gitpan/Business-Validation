package Business::Validation::Engine;

use strict;
use warnings;
use base 'Class::Accessor';
use Carp;

__PACKAGE__->follow_best_practice(); # Create get_ and set_ accessors.

sub new { 
    my ($class) = @_;

    $class = ( ref $class ) ? ref $class : $class;
    my $self = { results => undef };
    $class->mk_ro_accessors(keys %$self);
    return bless $self, $class;
}

sub validate {
    my ($self, $arg_ref) = @_;

    # Validate required params
    for my $param ( qw{ context collection } ) {
        croak "Required param '$param' not passed to validate()"
            if not $arg_ref->{$param};

        if ( $param eq 'collection' ) {
            croak q{collection is not a Business::Validation::Collection object}
                if not $arg_ref->{collection}->isa('Business::Validation::Collection');
        }
        elsif ( $param eq 'context' ) {
            croak q{context object does not have a param() method}
                if not $arg_ref->{context}->can('param');
        }
    }

    # Set the results in the engine.
    $self->{results} = $arg_ref->{collection}->validate($arg_ref->{context});

    # Return 1 if success, undef if failure.
    return $self->get_results()->get_status() ? 1 : undef;
}

1;

=pod

=head1 NAME

Business::Validation::Engine

=head1 DESCRIPTION

Business rules processing engine.

=head1 METHODS

=head2 new()

Creates a new Business::Validation::Engine object.

=head2 validate($context, $collections)

Takes a hashref with the following keys:

  context     => Business::Validation::Context object
  collections => Arrayref of Business::Validation::Collection objects.

  Returns true if validation succeeded or false if it fails.

=head2 get_results()

  Get the results object for the most recent validation.

=cut
