use strict;
use warnings;
use Math::Complex_C::Q qw(:all);

print "1..2\n";

my $c1 = MCQ(2.1,-5.1);

if(sprintf("%s", $c1) eq Math::Complex_C::Q::_overload_string($c1, 0, 0)) {print "ok 1\n"}
else {
  warn "\n$c1 ne ", Math::Complex_C::Q::_overload_string($c1, 0, 0), "\n";
  print "not ok 1\n";
}

my @ret = q_to_str($c1);

if("(@ret)" eq sprintf("%s", $c1)) {print "ok 2\n"}
else {
  warn "\n(@ret) ne ", sprintf("%s", $c1), "\n";
  print "not ok 2\n";
}



