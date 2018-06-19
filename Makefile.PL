#!perl

use strict;
use warnings;
use ExtUtils::MakeMaker;
use Devel::CheckLib;

#printf "Your OS is [%s]!\n---\n", $Config::Config{'osname'};  ### for testing purpose only

if (($Config::Config{'osname'} eq 'darwin')
    && !(join (' ', @ARGV) =~ /LDDLFLAGS/)) {
    ### reads pre-existing LDDLFLAGS for a darwin system as defined in
    ###  /System/Library/Perl/x.x.x/darwin-thread-multi-2level/Config.pm
    ###  where x.x.x is the perl version, which is 5.8.1 for MacOS X 10.3,
    ###  and appends ' -read_only_relocs suppress'
    ### default behavior if LDDLFLAGS is defined
    push @ARGV, sprintf("LDDLFLAGS=%s -read_only_relocs suppress",
                        $Config::Config{'lddlflags'});
}

my %WriteMakefile =
  (
   'NAME'               => 'Math::BigInt::GMP',
   'VERSION_FROM'       => 'lib/Math/BigInt/GMP.pm',
   'AUTHOR'             => 'Peter John Acklam <pjacklam@gmail.com>',
   'MIN_PERL_VERSION'   => 5.006001,
   'PREREQ_PM'          => {
                            #'ExtUtils::MakeMaker' => 6.58,
                            'XSLoader'            => 0.02,
                            'Test::More'          => 0.88,
                            'Math::BigInt'        => 1.999812,
                           },
   'CONFIGURE_REQUIRES' => {
                            'Devel::CheckLib' => 0,
                           },
   'LICENSE'            => 'perl_5',
   'SIGN'               => 1,
  );

if(check_lib(lib => 'gmp', header => 'gmp.h')) {
  $WriteMakefile{LIBS} = ['-lgmp'];
} else {
  $WriteMakefile{BUILD_REQUIRES} = {
                                    'Alien::Base::Wrapper' => 0,
                                    'Alien::GMP'           => 1.11,
  };
  $WriteMakefile{CC} = '$(FULLPERL) -Iinc -MAlien::Base::Wrapper=Alien::GMP -e cc --';
  $WriteMakefile{LD} = '$(FULLPERL) -Iinc -MAlien::Base::Wrapper=Alien::GMP -e ld --';
}

WriteMakefile(%WriteMakefile);
