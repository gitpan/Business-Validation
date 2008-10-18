package Business::Validation::Context;

use strict;
use warnings;
use base 'Class::Param';

1;

=pod

=head1 NAME

Business::Validation::Context

=head1 DESCRIPTION

Context object that holds all the data to be validated and used as supporting
data.

As of the current version, this module can be "hot-swapped" with any module that implements the param() method like CGI.pm.

=head1 METHODS

=head2 param()

   Similar to the CGI.pm param method.

=cut
