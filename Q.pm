use strict;
use warnings;
package Math::Complex_C::Q;

require Exporter;
*import = \&Exporter::import;
require DynaLoader;

use overload
    '**'    => \&_overload_pow,
    '*'     => \&_overload_mul,
    '+'     => \&_overload_add,
    '/'     => \&_overload_div,
    '-'     => \&_overload_sub,
    '**='   => \&_overload_pow_eq,
    '*='    => \&_overload_mul_eq,
    '+='    => \&_overload_add_eq,
    '/='    => \&_overload_div_eq,
    '-='    => \&_overload_sub_eq,
    'sqrt'  => \&_overload_sqrt,
    '=='    => \&_overload_equiv,
    '!='    => \&_overload_not_equiv,
    '!'     => \&_overload_not,
    'bool'  => \&_overload_true,
    '='     => \&_overload_copy,
    '""'    => \&_overload_string,
    'abs'   => \&_overload_abs,
    'exp'   => \&_overload_exp,
    'log'   => \&_overload_log,
    'sin'   => \&_overload_sin,
    'cos'   => \&_overload_cos,
;

our $VERSION = '0.01';

DynaLoader::bootstrap Math::Complex_C::Q $VERSION;

@Math::Complex_C::Q::EXPORT = ();
@Math::Complex_C::Q::EXPORT_OK = qw(

    create_cq assign_cq mul_cq mul_c_nvq mul_c_ivq mul_c_uvq div_cq div_c_nvq div_c_ivq div_c_uvq add_cq
    add_c_nvq add_c_ivq add_c_uvq sub_cq sub_c_nvq sub_c_ivq sub_c_uvq real_cq real_cq2Q imag_cq2Q Q2cq
    cq2Q real_cq2str imag_cq2str arg_cq2Q arg_cq2str abs_cq2Q abs_cq2str
    imag_cq arg_cq abs_cq conj_cq acos_cq asin_cq atan_cq cos_cq sin_cq tan_cq acosh_cq asinh_cq atanh_cq
    cosh_cq sinh_cq tanh_cq exp_cq log_cq sqrt_cq proj_cq pow_cq get_nanq get_infq is_nanq is_infq MCQ

    q_to_str q_to_strp q_set_prec q_get_prec
    );

%Math::Complex_C::Q::EXPORT_TAGS = (all => [qw(

    create_cq assign_cq mul_cq mul_c_nvq mul_c_ivq mul_c_uvq div_cq div_c_nvq div_c_ivq div_c_uvq add_cq
    add_c_nvq add_c_ivq add_c_uvq sub_cq sub_c_nvq sub_c_ivq sub_c_uvq real_cq real_cq2Q imag_cq2Q Q2cq
    cq2Q real_cq2str imag_cq2str arg_cq2Q arg_cq2str abs_cq2Q abs_cq2str
    imag_cq arg_cq abs_cq conj_cq acos_cq asin_cq atan_cq cos_cq sin_cq tan_cq acosh_cq asinh_cq atanh_cq
    cosh_cq sinh_cq tanh_cq exp_cq log_cq sqrt_cq proj_cq pow_cq get_nanq get_infq is_nanq is_infq MCQ

    q_to_str q_to_strp q_set_prec q_get_prec
    )]);

sub dl_load_flags {0} # Prevent DynaLoader from complaining and croaking

sub _overload_string {
    my($real, $imag) = (real_cq($_[0]), imag_cq($_[0]));
    my($r, $i) = q_to_str($_[0]);

    if($real == 0) {
      $r = $real =~ /^\-/ ? '-0' : '0';
    }
    elsif($real != $real) {
      $r = 'NaN';
    }
    elsif(($real / $real) != ($real / $real)) {
      $r = $real < 0 ? '-Inf' : 'Inf';
    }
    else {
      my @re = split /e/i, $r;
      while(substr($re[0], -1, 1) eq '0' && substr($re[0], -2, 1) ne '.') {
        chop $re[0];
      }
      $r = $re[0] . 'e' . $re[1];
    }

    if($imag == 0) {
      $i = $imag =~ /^\-/ ? '-0' : '0';
    }
    elsif($imag != $imag) {
      $i = 'NaN';
    }
    elsif(($imag / $imag) != ($imag / $imag)) {
      $i = $imag < 0 ? '-Inf' : 'Inf';
    }
    else {
      my @im = split /e/i, $i;
      while(substr($im[0], -1, 1) eq '0' && substr($im[0], -2, 1) ne '.') {
        chop $im[0];
      }
      $i = $im[0] . 'e' . $im[1];
    }

    return "(" . $r . " " . $i . ")";
}

sub new {


    # This function caters for 2 possibilities:
    # 1) that 'new' has been called OOP style - in which
    #    case there will be a maximum of 3 args
    # 2) that 'new' has been called as a function - in
    #    which case there will be a maximum of 2 args.
    # If there are no args, then we just want to return a
    # Math::Complex_C::Q object

    if(!@_) {return create_cq()}

    if(@_ > 3) {die "Too many arguments supplied to new()"}

    # If 'new' has been called OOP style, the first arg is the string
    # "Math::Complex_C::Q" which we don't need - so let's remove it.

    if(!ref($_[0]) && $_[0] eq "Math::Complex_C::Q") {
      shift;
      if(!@_) {return create_cq()}
    }

    if(@_ > 2) {die "Bad argument list supplied to new()"}

    my $ret;

    if(@_ == 2) {
      $ret = create_cq();
      assign_cq($ret, $_[0], $_[1]);
    }
    else {
      return $_[0] if _itsa($_[0]) == 226;
      $ret = create_cq();
      assign_cq($ret, $_[0], 0.0);
    }

    return $ret;
}

*MCQ = \&Math::Complex_C::Q::new;

1;

__END__

=head1 NAME

Math::Complex_C::Q - perl interface to C's __complex128 (quadmath) operations.

=head1 DEPENDENCIES

   In order to compile this module, a C compiler that provides the quadmath
   library is needed.

=head1 DESCRIPTION

   use warnings;
   use strict;
   use Math::Complex_C::Q qw(:all);
   # For brevity, use MCQ which is an alais for Math::Complex_C::new
   my $c =    MCQ(12.5, 1125); # assign as NV
   my $root = MCQ();

   sqrt_cq($root, $c);
   print "Square root of $c is $root\n";

   See also the Math::Complex_C::Q test suite for some (simplistic) examples
   of usage.

   The __complex128 data type consists of a __float128 real component and a
   __float128 imaginary component.
   As of perl-5.21.4, it is possible (on many systems) to build perl with an
   NV-type of __float128, and this module is written largely for the use of
   such perls. (Run "perl -V:nvtype" to see what your perl's NV type is.) If,
   however, your NV-type is either "double" or "long double", you can still
   utilise this module and the functions it contains. Two ways to do that:
    1) assign numeric strings to Math::Complex_C::Q objects and retrieve the
       values as numeric strings, eg:
        $obj = MCQ('2.3', '1.09'); # Assigns the __float128 values using C's
                                   # strtoflt128() function.

        ($r, $i) = q_to_str($obj); # Uses C's quadmath_snprintf() function;

    2) if you have Math::Float128,assign and retrieve Math::Float128 objects:
        $rop = MCQ($f_r, $f_i)  # Assigning values - see MCQ  docs, below.
        Q2cq($rop, $f_r, $f_i); # Assigning values - see Q2cq docs, below.
        cq2Q($f_r, $f_i, $op); # Retrieving values - see cq2Q docs, below.

=head1 FUNCTIONS

   $rop = Math::Complex_C::Q->new($re, $im);
   $rop = Math::Complex_C::Q::new($re, $im);
   $rop = MCQ($re, $im); # MCQ is an alias to Math::Complex_C::Q::new()
    $rop is a returned Math::Complex_C::Q object; $re and $im are the real and
    imaginary values (respectively) that $rop holds. They (ie $re, $im) can be
    integer values (IV or UV), floating point values (NV), numeric strings
    or Math::Float128 objects.Integer values (IV/UV) will be converted to floating
    point (NV) before being assigned. Note that the two arguments ($re $im) are
    optional - ie they can be omitted.
    If no arguments are supplied, then $rop will be assigned NaN for both the real
    and imaginary parts.
    If only one argument is supplied, and that argument is a Math::Complex_C::Q
    object then $rop will be a duplicate of that Math::Complex_C::Q object.
    Otherwise the single argument will be assigned to the real part of $rop, and
    the imaginary part will be set to zero.
    The functions croak if an invalid arg is supplied.

   $rop = create_cq();
    $rop is a Math::Complex_C::Q object, created with both real and imaginary
    values set to NaN. (Same result as calling new() without any args.)

   assign_cq($rop, $re, $im);
    The real part of $rop is set to the value of $re, the imaginary part is set to
    the value of $im. $re and $im can be  integers (IV or UV),  floating point
    values (NV), numeric strings, or Math::Float128 objects . Integer values (IV/UV)
    will be converted to floating point (NV) before being assigned.

   Q2cq($ropl, $r_f, $i_f); #$r_f & $i_f are Math::Float128 objects
    Assign the real and imaginary part of $ropl from the Math::Float128 objects $r_f
    and $i_f (respectively).

   mul_cq   ($rop, $op1, $op2);
   mul_cq_iv($rop, $op1, $si);
   mul_cq_uv($rop, $op1, $ui);
   mul_cq_nv($rop, $op1, $nv);
    Multiply $op1 by the 3rd arg, and store the result in $rop.
    The "3rd arg" is (respectively, from top) a Math::Complex_C::Q object,
    a signed integer value (IV), an unsigned integer value (UV), and a floating
    point value (NV).

   add_cq   ($rop, $op1, $op2);
   add_cq_iv($rop, $op1, $si);
   add_cq_uv($rop, $op1, $ui);
   add_cq_nv($rop, $op1, $nv);
    As for mul_cq(), etc., but performs addition.

   div_cq   ($rop, $op1, $op2);
   div_cq_iv($rop, $op1, $si);
   div_cq_uv($rop, $op1, $ui);
   div_cq_nv($rop, $op1, $nv);
    As for mul_cq(), etc., but performs division.

   sub_cq   ($rop, $op1, $op2);
   sub_cq_iv($rop, $op1, $si);
   sub_cq_uv($rop, $op1, $ui);
   sub_cq_nv($rop, $op1, $nv);
    As for mul_cq(), etc., but performs subtraction.

   $nv = real_cq($op);
    Returns the real part of $op as an NV. If your perl's NV is not __float128
    use either real_cq2Q() or real_cq2str().
    Wraps C's 'crealq' function.

   $nv = imag_cq($op);
    Returns the imaginary part of $op as an NV. If your perl's NV is not
    __float128 use either real_cq2Q() or real_cq2str().
    Wraps C's 'cimagq' function.

   $f = real_cq2Q($op);
   $f = imag_cq2Q($op);
    Returns a Math::Float128 object $f set to the value of $op's real (and
    respectively, imag) component. No point in using this function unless
    Math::Float128 is loaded.
    Wraps 'crealq' and 'cimagq' to obtain the values.

   $str = real_cq2str($op);
   $str = imag_cq2str($op);
    Returns a string set to the value of $op's real (and respectively, imag)
    component.
    Wraps 'crealq' and 'cimagq' to obtain the values.

   $nv = arg_cq($op);
    Returns the argument of $op as an NV.If your perl's NV is not
    __float128 use either arg_cq2Q() or arg_cq2str().
    Wraps C's 'cargq' function.

   $f = arg_cq2Q($op);
    Returns the Math::Float128 object $f, set to the value of the argument
    of $op. No point in using this function unless Math::Float128 is loaded.
    Wraps C's 'cargq' function.

   $str = arg_cq2str($op);
    Returns the string $str, set to the value of the argument of $op. No
    point in using this function unless Math::Float128 is loaded.
    Wraps C's 'cargq' function.

   $nv = abs_cq($op);
    Returns the absolute value of $op as an NV.If your perl's NV is not
    __float128 use either arg_cq2Q() or arg_cq2str().
    Wraps C's 'cabsq' function.

   $f = abs_cq2Q($op);
    Returns the Math::Float128 object $f, set to the absolute value of $op.
    No point in using this function unless Math::Float128 is loaded.
    Wraps C's 'cabsq' function.

   $str = abs_cq2str($op);
    Returns the string $str, set to the absolute value of $op. No point
    in using this function unless Math::Float128 is loaded.
    Wraps C's 'cabsq' function.

   conj_cq($rop, $op);
    Sets $rop to the conjugate of $op.
    Wraps C's 'conjq' function.

   acos_cq($rop, $op);
    Sets $rop to acos($op). Wraps C's 'cacosq' function.

   asin_cq($rop, $op);
    Sets $rop to asin($op). Wraps C's 'casinq' function.

   atan_cq($rop, $op);
    Sets $rop to atan($op). Wraps C's 'catanq' function.

   cos_cq($rop, $op);
    Sets $rop to cos($op). Wraps C's 'ccosq' function.

   sin_cq($rop, $op);
   sin_cl($ropl, $op);
    Sets $rop to sin($op). Wraps C's 'csinq' function.

   tan_cq($rop, $op);
    Sets $rop to tan($op). Wraps C's 'ctanq' function.

   acosh_cq($rop, $op);
    Sets $rop to acosh($op). Wraps C's 'cacoshq' function.

   asinh_cq($rop, $op);
    Sets $rop to asinh($op). Wraps C's 'casinhq' function.

   atanh_cq($rop, $op);
    Sets $rop to atanh($op). Wraps C's 'catanhq' function.

   cosh_cq($rop, $op);
    Sets $rop to cosh($op). Wraps C's 'ccoshq' function.

   sinh_cq($rop, $op);
    Sets $rop to sinh($op). Wraps C's 'csinhq' function.

   tanh_cq($rop, $op);
    Sets $rop to tanh($op). Wraps C's 'ctanhq' function.

   exp_cq($rop, $op);
    Sets $rop to e ** $op. Wraps C's 'cexpq' function.

   log_cq($rop, $op);
    Sets $rop to log($op). Wraps C's 'clogq' function.

   pow_cq($rop, $op1, $op2);
    Sets $rop to $op1 ** $op2. Wraps C's 'cpowq' function.

   sqrt_cq($rop, $op);
    Sets $rop to sqrt($op). Wraps C's 'csqrtq' function.

   proj_cq($rop, $op);
    Sets $rop to a projection of $op onto the Riemann sphere.
    Wraps C's 'cprojq' function.

   $rop = get_nanq();
    Sets $rop to NaN.

   $rop = get_infq();
    Sets $rop to Inf.

   $bool = is_nanq($op);
    Returns true if $op is a NaN - else returns false

   $bool = is_infq($op);
    Returns true if $op is -Inf or +Inf - else returns false


=head1 OUTPUT FUNCTIONS

   Default precision for output of Math::Complex_C::Q objects is whatever is
   specified by the macro FLT128_DIG in quadmath.h (usually 33). If FLT128_DIG
   is not defined then default precision is set to 33 decimal digits.

   This default can be altered using q_set_prec (see below).

   q_set_prec($si);
   $si = q_get_prec();
    Set/get the precision of output values

   $str = q_to_str($op);
    Express the value of $op in a string of the form "(real imag)".
    Both "real" and "imag" will be expressed in scientific
    notation, to the precision returned by the q_get_prec() function (above).
    Use q_set_prec() to alter this precision.
    The representation of Infs and NaNs will be platform-dependent.

   $str = q_to_strp($op, $si);
    As for q_to_str, except that the precision setting for the output value
    is set by the 2nd arg (which must be greater than 1).

   cq2Q($f_r, $f_i, $op);
    Assign the real part of $op to the Math::Float128 object $f_r, and the
    imaginary part of $op to the Math::Float128 object $f_i.


=head1 OPERATOR OVERLOADING

   Math::Complex_C::Q overloads the following operators:
    *, +, /, -, **,
    *=, +=, /=, -=, **=,
    !, bool,
    ==, !=,
    =, "",
    abs, exp, log, cos, sin, atan2, sqrt

    Overloaded operations are provided the following types:
     IV, UV, NV, PV, Math::Complex_C::Q object.
   .

    Note: For the purposes of the overloaded 'not', '!' and 'bool'
    operators, a "false" Math::Complex_C object is one with real
    and imaginary parts that are both "false" - where "false"
    currently means either 0 (including -0) or NaN.
    (A "true" Math::Complex_C object is, of course, simply one
    that is not "false".)


=head1 LICENSE

   This module is free software; you may redistribute it and/or
   modify it under the same terms as Perl itself.
   Copyright 2011, 2013, 2014, Sisyphus.

=head1 AUTHOR

   Sisyphus <sisyphus at(@) cpan dot (.) org>

=cut
