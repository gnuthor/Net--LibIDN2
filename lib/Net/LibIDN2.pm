# vim:set tabstop=4 shiftwidth=4 noexpandtab:

package Net::LibIDN2;

use 5.006;
use strict;
use warnings;

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

our %EXPORT_TAGS = ( 'all' => [ qw(
	idn2_strerror
	idn2_strerror_name
	idn2_lookup_u8
	idn2_lookup_ul
	idn2_register_u8
	idn2_register_ul
	IDN2_NFC_INPUT
	IDN2_ALABEL_ROUNDTRIP
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	IDN2_NFC_INPUT
	IDN2_ALABEL_ROUNDTRIP
);
our $VERSION = '0.02';

bootstrap Net::LibIDN2 $VERSION;

1;
__END__

=encoding utf8

=head1 NAME

Net::LibIDN2 - Perl bindings for GNU Libidn2

=head1 SYNOPSIS

  use Net::LibIDN2 ':all';

  idn2_lookup("müßli.de") eq 'xn--mli-5ka8l.de';
  
  idn2_register("müßli", "xn--mli-5ka8l") eq 'xn--mli-5ka8l.de';

=head1 DESCRIPTION

Provides bindings for GNU Libidn2, a C library for handling internationalized
domain names according to IDNA 2008 (RFC 5890, RFC 5891, RFC 5892, RFC 5893)

=head2 Functions

=over 4

=item B<Net::LibIDN2::idn2_lookup_u8>(I<$src>, [I<$flags>, [I<$rc>]]);

Perform IDNA2008 lookup string conversion on domain name I<$src> (encoded in UTF-8),
as described in section 5 of RFC 5891. Note that I<$src> must be in Unicode NFC form.

Pass B<IDN2_NFC_INPUT> in I<$flags> to convert input to NFC form before further
processing. Pass B<IDN2_ALABEL_ROUNDTRIP> in I<$flags> to convert any input
A-labels to U-labels and perform additional testing. Multiple flags may
be specified by binary or:ing them together, for example
B<IDN2_NFC_INPUT> | B<IDN2_ALABEL_ROUNDTRIP>.

On error, returns undef. If a scalar variable is provided in I<$rc>, 
returns the internal libidn2 C library result code as well.

=item B<Net::LibIDN2::idn2_register_u8>(I<$ulabel>, [I<$alabel>, [I<$flags>, [I<$rc>]]]);

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

=item B<Net::LibIDN2::idn2_strerror>(I<$rc>);

Convert internal libidn2 error code I<$rc> to a humanly readable string.

=item B<Net::LibIDN2::idn2_strerror_name>(I<$rc>);

Convert internal libidn2 error code I<$rc> to a string corresponding to
internal header file symbols names like IDN2_MALLOC.

=back

=head2 Result codes

=over 4

=item B<"IDN2_OK">
Successful return.

=item B<"IDN2_MALLOC">
Memory allocation error.

=item B<"IDN2_NO_CODESET">
Could not determine locale string encoding format.

=item B<"IDN2_ICONV_FAIL">
Could not transcode locale string to UTF-8.

=item B<"IDN2_ENCODING_ERROR">
Unicode data encoding error.

=item B<"IDN2_NFC">
Error normalizing string.

=item B<"IDN2_PUNYCODE_BAD_INPUT">
Punycode invalid input.

=item B<"IDN2_PUNYCODE_BIG_OUTPUT">
Punycode output buffer too small.

=item B<"IDN2_PUNYCODE_OVERFLOW">
Punycode conversion would overflow.

=item B<"IDN2_TOO_BIG_DOMAIN">
Domain name longer than 255 characters.

=item B<"IDN2_TOO_BIG_LABEL">
Domain label longer than 63 characters.

=item B<"IDN2_INVALID_ALABEL">
Input A-label is not valid.

=item B<"IDN2_UALABEL_MISMATCH">
Input A-label and U-label does not match.

=item B<"IDN2_NOT_NFC">
String is not NFC.

=item B<"IDN2_2HYPHEN">
String has forbidden two hyphens.

=item B<"IDN2_HYPHEN_STARTEND">
String has forbidden starting/ending hyphen.

=item B<"IDN2_LEADING_COMBINING">
String has forbidden leading combining character.

=item B<"IDN2_DISALLOWED">
String has disallowed character.

=item B<"IDN2_CONTEXTJ">
String has forbidden context-j character.

=item B<"IDN2_CONTEXTJ_NO_RULE">
String has context-j character with no rull.

=item B<"IDN2_CONTEXTO">
String has forbidden context-o character.

=item B<"IDN2_CONTEXTO_NO_RULE">
String has context-o character with no rull.

=item B<"IDN2_UNASSIGNED">
String has forbidden unassigned character.

=item B<"IDN2_BIDI">
String has forbidden bi-directional properties.

=back

=head2 Limitations

Not sure if it works with Perl builtin unicode support.

=head1 AUTHOR

Thomas Jacob, http://internet24.de

=head1 SEE ALSO

perl(1), RFC 5890-5893, http://www.gnu.org/software/libidn.

=cut
