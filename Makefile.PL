use ExtUtils::MakeMaker;
use lib 'inc'; # load our bundled version of Devel::CheckLib
use Devel::CheckLib;

#printf "Your OS is [%s]!\n---\n", $Config::Config{'osname'};  ### for testing purpose only

if (($Config::Config{'osname'} eq 'darwin') &! (join (' ', @ARGV) =~ /LDDLFLAGS/))
  {
  ### reads pre-existing LDDLFLAGS for a darwin system as defined in
  ###  /System/Library/Perl/x.x.x/darwin-thread-multi-2level/Config.pm
  ###  where x.x.x is the perl version, which is 5.8.1 for MacOS X 10.3,
  ###  and appends ' -read_only_relocs suppress'
  ### default behavior if LDDLFLAGS is defined
  push @ARGV, sprintf "LDDLFLAGS=%s -read_only_relocs suppress", $Config::Config{'lddlflags'};
  }

check_lib_or_exit(lib => 'gmp', header => 'gmp.h', @ARGV);

WriteMakefile
  (
   'NAME'              => 'Math::BigInt::GMP',
   'AUTHOR'            => 'Tels',
   'VERSION_FROM'      => 'lib/Math/BigInt/GMP.pm',
   'LICENSE'           => 'perl',
   'INSTALLDIRS'       => 'site',
   'ABSTRACT_FROM'     => 'lib/Math/BigInt/GMP.pm',
   'PREREQ_PM'         => {
                           Math::BigInt => 1.997,
                           XSLoader => 0.02,
                          },
   'LIBS'              => ['-lgmp'],
   'SIGN' => 1,
  );
