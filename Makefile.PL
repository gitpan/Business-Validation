use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    NAME         => 'Business::Validation',
    VERSION_FROM => 'lib/Business/Validation.pm', # finds \$VERSION
    AUTHOR       => 'Bob Stockdale (stocks@cpan.org)',
    ABSTRACT     => 'Business rule validation framework.',
    PREREQ_FATAL => 1,
    PREREQ_PM    => {
                        'Class::Param'     => undef,
                        'Class::Accessor'  => undef,
                        'Params::Validate' => undef,
                        'version'          => undef,
                    },
);
