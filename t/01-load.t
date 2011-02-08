#!/usr/bin/perl -w

use strict;             # restrict unsafe constructs

use Test::More tests => 1;
BEGIN { use_ok('Math::BigInt::GMP') };

diag("Testing Math::BigInt::GMP $Math::BigInt::GMP::VERSION, Perl $], $^X");
