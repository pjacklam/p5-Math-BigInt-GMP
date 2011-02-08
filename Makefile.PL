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

sub MY::metafile {
  package MY;
  my $self = shift;
  if (!eval { require YAML; 1 })
    {
    warn ("YAML not installed, make dist will not override metafile");
    return $self->SUPER::metafile_target(@_);
    }

  require YAML::Node;
  my $node = new YAML::Node {};

  $node->{name}                 = $self->{DISTNAME};
  $node->{author}               = 'Tels';
  $node->{version}              = $self->{VERSION};
  $node->{version_from}         = $self->{VERSION_FROM};
  $node->{license}              = 'perl';
  $node->{distribution_type}    = 'module';
  $node->{generated_by}         = "$self->{DISTNAME} version $self->{VERSION}";
  $node->{installdirs}          = 'site';
  $node->{requires}             = $self->{PREREQ_PM};

  my $dump = YAML::Dump( $node );

  $dump =~ s/^(.*)$/\t\$(NOECHO) \$(ECHO) "$1" >>META.yml/gm;
  $dump =~ s/>>META\.yml/>META.yml/;

  "metafile:\n$dump";
  }

check_lib_or_exit(lib => 'gmp', header => 'gmp.h', @ARGV);

WriteMakefile(
    'NAME'              => 'Math::BigInt::GMP',
    'VERSION_FROM'      => 'lib/Math/BigInt/GMP.pm',
    'PREREQ_PM'         => {
                                Math::BigInt => 1.99_05,
                                XSLoader => 0.02,
                           },
    'LIBS'              => ['-lgmp'],
    'SIGN' => 1,
);
