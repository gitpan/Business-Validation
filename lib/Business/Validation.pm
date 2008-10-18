package Business::Validation;

use strict;
use vars qw($VERSION);
require version;

BEGIN {
    $VERSION = version->new('0.02');
}

1;

=head1 NAME

Business::Validation - Business rule validation framework.

=head1 SYNOPSIS

 # create business rules
 my $rule1 = Business::Validation::Rule::AlwaysFail();
 my $rule2 = Some::Business::Validation::Rule::SubClass->new(
    { something => 'someval' });

 # add the rules to a collection
 my $collection = Business::Validation::Collection->new(
    { rules => [ $rule1, $rule2 ] });


 # pass your context, full of data to be validated along with the
 # collection into the engine.
 my $engine  = Business::Validation::Engine->new();
 my $success = $engine->validate({
     context    => $context,     # Has a param() method like CGI.pm
     collection => $collection,
 });

 if ( not $success ) {
     my $results = $engine->get_results();
     # Do something with results...
 }
     
 

=head1 DESCRIPTION


=head1 BUGS

None so far...


=head1 AUTHOR

    Bob Stockdale
    CPAN ID: STOCKS

=head1 COPYRIGHT

This program is free software licensed under the...

	The General Public License (GPL)
	Version 2, June 1991

The full text of the license can be found in the
LICENSE file included with this module.


=cut

