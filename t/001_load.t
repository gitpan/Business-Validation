# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'Business::Validation::Rule' ); }

my $object = Business::Validation::Rule->new ();
isa_ok ($object, 'Business::Validation::Rule');


