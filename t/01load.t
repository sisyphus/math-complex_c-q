use strict;
use warnings;

print "1..2\n";

eval {require Math::Complex_C::Q;};

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

