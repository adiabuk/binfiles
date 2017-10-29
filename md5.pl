#!/usr/bin/env perl

# Print md5 and md5_hex encrypted passwords with salt
# Usage ./md5.pl <password> md5|md5_hex
# Author: Amro Diab
# Date: 03/11/2009

use warnings;
use strict;
use lib "/opt/otrs/Kernel/cpan-lib";
use Crypt::PasswdMD5 qw(unix_md5_crypt);
use Digest::MD5 qw(md5 md5_hex);

my $num_args = $#ARGV + 1;
if ($num_args != 2) {
    die "\nUsage: $0 <password> md5|md5_hex\n";
  }
my $password = $ARGV[0];
my $enc= $ARGV[1];

my $salt = "1d";

my $newstring = $salt . $password;

print "password = $password\n";
print "salt = $salt\n";
my $encrypted;
if ($enc eq "md5") {
  $encrypted = md5_hex ($newstring);
  print "type = md5\n"
}
else {
$encrypted = unix_md5_crypt ($newstring);
  print "type = md5_hex\n"
}
print "encrypted = $encrypted:$salt\n";


