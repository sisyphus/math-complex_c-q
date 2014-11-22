use strict;
use warnings;

print "1..3\n";

eval {require Math::Complex_C::Q; Math::Complex_C::Q->import('q_get_prec', 'q_set_prec');};

if($@) {
  warn "\$\@: $@";
  print "not ok 1\n";
}
else {print "ok 1\n"}

if($Math::Complex_C::Q::VERSION eq '0.01') {
  print "ok 2\n";
}
else {
  warn "version: $Math::Complex_C::Q::VERSION\n";
  print "not ok 2\n";
}

warn "\nDefault decimal precision is ", q_get_prec(), "\n";

my $new_set = 5 + q_get_prec();

q_set_prec($new_set);

if($new_set == q_get_prec()) {print "ok 3\n"}
else {
  warn "\nExpected $new_set\nGot ", q_get_prec(), "\n";
  print "not ok 3\n";
}


