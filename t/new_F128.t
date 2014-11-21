use strict;
use warnings;
use Math::Complex_C::Q qw(:all);

eval{require Math::Float128;};

if($@) {
  print "1..1\n";
  warn "Skipping all tests as Math::Float128 is not available:\n$@\n";
  print "ok 1\n";
  exit 0;
}

print "1..3\n";

my $f_r = Math::Float128->new('3.1');
my $f_i = Math::Float128->new('-5.1');

my $root_2 = sqrt(Math::Float128->new(2.0));

my $c1 = MCQ('3.1', '-5.1');
my $c2 = MCQ($f_r, $f_i);

if($c1 == $c2) {print "ok 1\n"}
else {
  warn "\n$c1 != $c2\n";
  print "not ok 1\n";
}

my $c3 = sqrt(MCQ(-2, 0));
if($c3 == MCQ(0, $root_2)) {print "ok 2\n"}
else {
  warn"\n$c3 != ", MCQ(0, $root_2), "\n";
  print "not ok 2\n";
}

my $c4 = Math::Complex_C::Q->new($f_r, $f_i);
if($c4 == $c2) {print "ok 3\n"}
else {
  warn "\n$c4 != $c2\n";
  print "not ok 3\n";
}
