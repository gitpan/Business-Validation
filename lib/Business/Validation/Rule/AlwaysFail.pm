package Business::Validation::Rule::AlwaysFail;

use strict;
use warnings;
use base 'Business::Validation::Rule';

sub validate {
    my ($self) = @_;

    $self->set_message({ 
        param   => '',
        message => 'This always fails.',
    });

    return;
}

1;

=pod

=head1 NAME

Business::Validation::Rule::AlwaysFail

=head1 DESCRIPTION

A Business::Validation::Rule whose validate method always returns failure.

=cut
