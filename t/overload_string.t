use strict;
use warnings;
use Math::Complex_C::Q qw(:all);

print "1..5\n";

my $c1 = MCQ(2.1,-5.1);

if(sprintf("%s", $c1) eq Math::Complex_C::Q::_overload_string($c1, 0, 0)) {print "ok 1\n"}
else {
  warn "\n$c1 ne ", Math::Complex_C::Q::_overload_string($c1, 0, 0), "\n";
  print "not ok 1\n";
}

my $ret = q_to_str($c1);

if("($ret)" eq sprintf("%s", $c1)) {print "ok 2\n"}
else {
  warn "\n$ret ne ", sprintf("%s", $c1), "\n";
  print "not ok 2\n";
}

my $str1 = q_to_str(MCQ());
my $str2 = q_to_strp(MCQ(), 2 + q_get_prec());

if($str1 eq $str2 && $str1 eq 'nan nan') {print "ok 3\n"}
else {
  warn "\nExpected 'nan nan'\nGot '$str1' and '$str2'\n";
  print "not ok 3\n";
}

my $cinf = (MCQ(1, 1) / MCQ(0, 0));

$str1 = q_to_str($cinf);
$str2 = q_to_strp($cinf, 2 + q_get_prec());

if($str1 eq $str2 && $str1 eq 'inf inf') {print "ok 4\n"}
else {
  warn "\nExpected 'inf inf'\nGot '$str1' and '$str2'\n";
  print "not ok 4\n";
}

$cinf *= MCQ(-1, 0);

$str1 = q_to_str($cinf);
$str2 = q_to_strp($cinf, 2 + q_get_prec());

if($str1 eq $str2 && $str1 eq '-inf -inf') {print "ok 5\n"}
else {
  warn "\nExpected '-inf -inf'\nGot '$str1' and '$str2'\n";
  print "not ok 5\n";
}

