#!/usr/bin/perl -w

use Test;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../lib'; # for running manually
  my $location = $0; $location =~ s/bigintpm.t//;
  unshift @INC, $location; # to locate the testing files
  # chdir 't' if -d 't';
  plan tests => 1591;
  }

use Math::BigInt lib => 'GMP';

use vars qw ($scale $class $try $x $y $f @args $ans $ans1 $ans1_str $setup);
$class = "Math::BigInt";

require 'bigintpm.inc';	# all tests here for sharing