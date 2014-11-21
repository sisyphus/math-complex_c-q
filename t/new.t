use strict;
use warnings;
use Math::Complex_C::Q qw(:all);
use Config;

print "1..4\n";


my $f128 = $Config{nvtype} eq '__float128' ? 1 : 0;


my $c1 = MCQ('3.1', '-5.1');
my $c2 = MCQ(3.1, -5.1);

if   ($c1 == $c2 &&  $f128) {print "ok 1\n"}
elsif($c1 != $c2 && !$f128) {print "ok 1\n"}
else {
  warn "\n\$f128: $f128\n\$c1: $c1\n\$c2: $c2\n";
  print "not ok 1\n";
}

assign_cq($c1, 2.0, 17);
assign_cq($c2, 2, 17.0);

if($c1 == $c2) {print "ok 2\n"}
else {
  warn "\n$c1 != $c2\n";
  print "not ok 2\n";
}

assign_cq($c1, '2.0', 17);
assign_cq($c2, 2, '17.0');

if($c1 == $c2) {print "ok 3\n"}
else {
  warn "\n$c1 != $c2\n";
  print "not ok 3\n";
}

my $c3 = Math::Complex_C::Q->new(2.0, 17);
my $c4 = Math::Complex_C::Q->new('2.0', 17);
my $c5 = Math::Complex_C::Q->new(2.0, '17');

if($c3 == $c4 && $c3 == $c5) {print "ok 4\n"}
else {
  warn "\n\$c3: $c3\n\$c4: $c4\n\$c5: $c5\n";
  print "not ok 4\n";
}
