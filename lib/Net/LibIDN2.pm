# vim:set tabstop=4 shiftwidth=4 noexpandtab:

package Net::LibIDN2;

use 5.006;
use strict;
use warnings;

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

our $VERSION = '1.01';
bootstrap Net::LibIDN2 $VERSION;

our %EXPORT_TAGS = ( 'all' => [ qw(
	idn2_strerror
	idn2_strerror_name
	idn2_check_version
	idn2_lookup_u8
	idn2_lookup_ul
	idn2_register_u8
	idn2_register_ul
	IDN2_OK
	IDN2_MALLOC
	IDN2_NO_CODESET
	IDN2_ICONV_FAIL
	IDN2_ENCODING_ERROR
	IDN2_NFC
	IDN2_PUNYCODE_BAD_INPUT
	IDN2_PUNYCODE_BIG_OUTPUT
	IDN2_PUNYCODE_OVERFLOW
	IDN2_TOO_BIG_DOMAIN
	IDN2_TOO_BIG_LABEL
	IDN2_INVALID_ALABEL
	IDN2_UALABEL_MISMATCH
	IDN2_INVALID_FLAGS
	IDN2_NOT_NFC
	IDN2_2HYPHEN
	IDN2_HYPHEN_STARTEND
	IDN2_LEADING_COMBINING
	IDN2_DISALLOWED
	IDN2_CONTEXTJ
	IDN2_CONTEXTJ_NO_RULE
	IDN2_CONTEXTO
	IDN2_CONTEXTO_NO_RULE
	IDN2_UNASSIGNED
	IDN2_BIDI
	IDN2_DOT_IN_LABEL
	IDN2_INVALID_TRANSITIONAL
	IDN2_INVALID_NONTRANSITIONAL
	IDN2_VERSION
	IDN2_VERSION_NUMBER
	IDN2_VERSION_MAJOR
	IDN2_VERSION_MINOR
	IDN2_VERSION_PATCH
	IDN2_LABEL_MAX_LENGTH
	IDN2_DOMAIN_MAX_LENGTH
	IDN2_NFC_INPUT
	IDN2_ALABEL_ROUNDTRIP
	IDN2_TRANSITIONAL
	IDN2_NONTRANSITIONAL
	IDN2_ALLOW_UNASSIGNED
	IDN2_USE_STD3_ASCII_RULES
) ] );

if (idn2_check_version("2.0.5")) {
	push @{$EXPORT_TAGS{all}}, "IDN2_NO_TR46";
}
if (idn2_check_version("2.2.0")) {
	push @{$EXPORT_TAGS{all}}, "IDN2_ALABEL_ROUNDTRIP_FAILED";
	push @{$EXPORT_TAGS{all}}, "IDN2_NO_ALABEL_ROUNDTRIP";
}

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	IDN2_VERSION
	IDN2_VERSION_NUMBER
	IDN2_VERSION_MAJOR
	IDN2_VERSION_MINOR
	IDN2_VERSION_PATCH
	IDN2_LABEL_MAX_LENGTH
	IDN2_DOMAIN_MAX_LENGTH
	IDN2_NFC_INPUT
	IDN2_ALABEL_ROUNDTRIP
	IDN2_TRANSITIONAL
	IDN2_NONTRANSITIONAL
	IDN2_ALLOW_UNASSIGNED
	IDN2_USE_STD3_ASCII_RULES
);

if (idn2_check_version("2.0.5")) {
	push @EXPORT, "IDN2_NO_TR46";
}
if (idn2_check_version("2.2.0")) {
	push @EXPORT, "IDN2_NO_ALABEL_ROUNDTRIP";
}

1;
__END__

=encoding utf8

=head1 NAME

Net::LibIDN2 - Perl bindings for GNU Libidn2

=head1 SYNOPSIS

  use Net::LibIDN2 ':all';

  idn2_lookup_u8(Encode::encode_utf8("m\N{U+00FC}\N{U+00DF}li.de"))
    eq 'xn--mli-5ka8l.de';

  idn2_register_u8(
    Encode::encode_utf8("m\N{U+00FC}\N{U+00DF}li"),
    "xn--mli-5ka8l"
  ) eq 'xn--mli-5ka8l';

  Encode::decode_utf8(idn2_to_unicode_88("xn--mli-5ka8l.de"))
    eq "m\N{U+00FC}\N{U+00DF}li"

=head1 DESCRIPTION

Provides bindings for GNU Libidn2, a C library for handling internationalized
domain names based on IDNA 2008, Punycode and TR46. 

=head2 Functions

=over 4

=item B<Net::LibIDN2::idn2_lookup_u8>(I<$src> [, I<$flags> [, I<$rc>]]);

Alternative name idn2_to_ascii_8.

Perform IDNA2008 lookup string conversion on domain name $I<src>, as described in 
section 5 of RFC 5891. Note that the input string must be encoded in UTF-8 and
be in Unicode NFC form.

Pass B<IDN2_NFC_INPUT> in I<$flags> to convert input to NFC form before further
processing. IDN2_TRANSITIONAL and IDN2_NONTRANSITIONAL do already imply IDN2_NFC_INPUT.

Pass B<IDN2_ALABEL_ROUNDTRIP> in flags to convert any input A-labels
to U-labels and perform additional testing. This is default if used with a libidn 
version >= 2.2. To switch this behavior off, pass IDN2_NO_ALABEL_ROUNDTRIP

Pass IDN2_TRANSITIONAL to enable Unicode TR46 transitional processing, and
IDN2_NONTRANSITIONAL to enable Unicode TR46 non-transitional processing. 

Multiple flags may be specified by binary or:ing them together, for example
B<IDN2_NFC_INPUT> | B<IDN2_ALABEL_ROUNDTRIP>.

If linked to library GNU Libidn version > 2.0.3: IDN2_USE_STD3_ASCII_RULES disabled by default.
Previously we were eliminating non-STD3 characters from domain strings such as
_443._tcp.example.com, or IPs 1.2.3.4/24 provided to libidn2 functions.
That was an unexpected regression for applications switching from libidn 
and thus it is no longer applied by default. Use IDN2_USE_STD3_ASCII_RULES
to enable that behavior again.

On error, returns undef. If a scalar variable is provided in I<$rc>, 
returns the internal libidn2 C library result code as well.

=item B<Net::LibIDN2::idn2_lookup_ul>(I<$src> [, I<$flags> [, I<$rc>]]);

Alternative name idn2_to_ascii_l.

Similar to function C<idn2_lookup_u8> but I<$src> is assumed to be encoded in 
the locale's default coding system, and will be transcoded to UTF-8 and NFC 
normalized before returning the result.

=item B<Net::LibIDN2::idn2_register_u8>(I<$ulabel> [, I<$alabel>, [I<$flags>, [I<$rc>]]]);

Perform IDNA2008 register string conversion on domain label I<$ulabel> and I<$alabel>,
as described in section 4 of RFC 5891. Note that the input ulabel must be encoded 
in UTF-8 and be in Unicode NFC form.

Pass B<IDN2_NFC_INPUT> in I<$flags> to convert input I<$ulabel> to NFC form before
further processing.

It is recommended to supply both I<$ulabel> and I<$alabel> for better error checking,
but supplying just one of them will work. Passing in only I<$alabel> is better than
only I<$ulabel>. See RFC 5891 section 4 for more information.

On error, returns undef. If a scalar variable is provided in I<$rc>, 
returns the internal libidn2 C library result code as well.

=item B<Net::LibIDN2::idn2_register_u8>(I<$ulabel> [, I<$alabel>, [I<$flags>, [I<$rc>]]]);

Similar to function C<idn2_register_ul> but I<$ulabel> is assumed to be encoded in 
the locale's default coding system, and will be transcoded to UTF-8 and NFC 
normalized before returning the result.

=item B<Net::LibIDN2::idn2_to_unicode_88>(I<$input>, [I<$flags>, [I<$rc>]]);

Converts a possibly ACE encoded domain name in UTF-8 format into a
an UTF-8 encoded string (punycode decoding).

On error, returns undef. If a scalar variable is provided in I<$rc>, 
returns the internal libidn2 C library result code as well.

=item B<Net::LibIDN2::idn2_to_unicode_8l>(I<$input>, [I<$flags>, [I<$rc>]]);

Similar to function C<idn2_to_unicode_88> but the return value is encoded in 
the locale's default coding system.

=item B<Net::LibIDN2::idn2_to_unicode_ll>(I<$input>, [I<$flags>, [I<$rc>]]);

Similar to function C<idn2_to_unicode_8l> but I<$input> is also assumed to be encoded in 
the locale's default coding system.

=item B<Net::LibIDN2::idn2_strerror>(I<$rc>);

Convert internal libidn2 error code I<$rc> to a humanly readable string.

=item B<Net::LibIDN2::idn2_strerror_name>(I<$rc>);

Convert internal libidn2 error code I<$rc> to a string corresponding to
internal header file symbols names like IDN2_MALLOC.

=item B<Net::LibIDN2::id2n_check_version>([I<$req_version>])

Checks that the version of the underlying IDN2 C library is at minimum
the one given as a string in I<$req_version> and if that is the case
returns the actual version string  of the underlying C library or undef
if the condition is not met. If no parameter is passed to this function
no check is done and only the version  string is returned.

See B<IDN2_VERSION> for a suitable I<$req_version> string, it corresponds
to  the idn2.h C header file version at compile time of this Perl module.
Normally these two version numbers match, but if you compiled this Perl
module against an older libidn2  and then run it with a newer libidn2
shared library they will be different.

=back

=head2 Constants

=over 4

=item B<IDN2_VERSION>

Pre-processor symbol with a string that describe the C header file version
number at compile time of this Perl module. Used together with idn2_check_version()
to verify header file and run-time library consistency.

=item B<IDN2_VERSION_NUMBER>

Pre-processor symbol with a hexadecimal value describing the C header file
version number at compile time of this Perl module. For example, when the header 
version is 1.2.4711 this symbol will have the value 0x01021267. The last four
digits are used to enumerate development snapshots, but for all public releases
they will be 0000.

=item B<IDN2_VERSION_MAJOR>

Pre-processor symbol for the major version number (decimal).
The version scheme is major.minor.patchlevel.

=item B<IDN2_VERSION_MINOR>

Pre-processor symbol for the minor version number (decimal).
The version scheme is major.minor.patchlevel.

=item B<IDN2_VERSION_PATCH>

Pre-processor symbol for the patch level number (decimal).
The version scheme is major.minor.patchlevel.

=item B<IDN2_LABEL_MAX_LENGTH>

Constant specifying the maximum length of a DNS label to 63 characters,
as specified in RFC 1034.

=item B<IDN2_DOMAIN_MAX_LENGTH>

Constant specifying the maximum size of the wire encoding of a DNS domain to 255
characters, as specified in RFC 1034. Note that the usual printed representation
of a domain name is limited to 253 characters if it does not end with a period
or 254 characters if it ends with a period. 

=back

=head2 Result codes

=over 4

=item B<"Net::LibIDN2::IDN2_OK">
Successful return.

=item B<"Net::LibIDN2::IDN2_MALLOC">
Memory allocation error.

=item B<"Net::LibIDN2::IDN2_NO_CODESET">
Could not determine locale string encoding format.

=item B<"Net::LibIDN2::IDN2_ICONV_FAIL">
Could not transcode locale string to UTF-8.

=item B<"Net::LibIDN2::IDN2_ENCODING_ERROR">
Unicode data encoding error.

=item B<"Net::LibIDN2::IDN2_NFC">
Error normalizing string.

=item B<"Net::LibIDN2::IDN2_PUNYCODE_BAD_INPUT">
Punycode invalid input.

=item B<"Net::LibIDN2::IDN2_PUNYCODE_BIG_OUTPUT">
Punycode output buffer too small.

=item B<"Net::LibIDN2::IDN2_PUNYCODE_OVERFLOW">
Punycode conversion would overflow.

=item B<"Net::LibIDN2::IDN2_TOO_BIG_DOMAIN">
Domain name longer than 255 characters.

=item B<"Net::LibIDN2::IDN2_TOO_BIG_LABEL">
Domain label longer than 63 characters.

=item B<"Net::LibIDN2::IDN2_INVALID_ALABEL">
Input A-label is not valid.

=item B<"Net::LibIDN2::IDN2_UALABEL_MISMATCH">
Input A-label and U-label does not match.

=item B<"Net::LibIDN2::IDN2_NOT_NFC">
String is not NFC.

=item B<"Net::LibIDN2::IDN2_2HYPHEN">
String has forbidden two hyphens.

=item B<"Net::LibIDN2::IDN2_HYPHEN_STARTEND">
String has forbidden starting/ending hyphen.

=item B<"Net::LibIDN2::IDN2_LEADING_COMBINING">
String has forbidden leading combining character.

=item B<"Net::LibIDN2::IDN2_DISALLOWED">
String has disallowed character.

=item B<"Net::LibIDN2::IDN2_CONTEXTJ">
String has forbidden context-j character.

=item B<"Net::LibIDN2::IDN2_CONTEXTJ_NO_RULE">
String has context-j character with no rull.

=item B<"Net::LibIDN2::IDN2_CONTEXTO">
String has forbidden context-o character.

=item B<"Net::LibIDN2::IDN2_CONTEXTO_NO_RULE">
String has context-o character with no rull.

=item B<"Net::LibIDN2::IDN2_UNASSIGNED">
String has forbidden unassigned character.

=item B<"Net::LibIDN2::IDN2_BIDI">
String has forbidden bi-directional properties.

=item B<"Net::LibIDN2::IDN2_DOT_IN_LABEL">
Label has forbidden dot (TR46).

=item B<"Net::LibIDN2::IDN2_INVALID_TRANSITIONAL">
Label has character forbidden in transitional mode (TR46).

=item B<"Net::LibIDN2::IDN2_INVALID_NONTRANSITIONAL">
Label has character forbidden in non-transitional mode (TR46).

=back

=head1 AUTHOR

Thomas Jacob, https://github.com/gnuthor

=head1 SEE ALSO

perl(1), RFC 5890-5893, TR 46, https://gitlab.com/libidn/libidn2.

=cut
