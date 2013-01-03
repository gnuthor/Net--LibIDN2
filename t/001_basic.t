# vim:set tabstop=4 shiftwidth=4 noexpandtab:

use strict;
use warnings;

use Test::More tests => 29;

BEGIN { use_ok( 'Net::LibIDN2'); }

ok(length(IDN2_VERSION)>0);
ok(IDN2_VERSION_NUMBER>0);
ok(IDN2_LABEL_MAX_LENGTH>32);
ok(IDN2_DOMAIN_MAX_LENGTH>32);

is(IDN2_NFC_INPUT, 1);
is(IDN2_ALABEL_ROUNDTRIP, 2);

is(Net::LibIDN2::idn2_strerror(0), 'success');
is(Net::LibIDN2::idn2_strerror_name(0), 'IDN2_OK');

{
	my $result = Net::LibIDN2::idn2_lookup_u8("müßli.de");

	is($result, "xn--mli-5ka8l.de");
}

{
	my $rc = 0;
	my $result = Net::LibIDN2::idn2_lookup_u8(
		"\x65\x78\x61\x6d\x70\x6c\x65\x2e\xe1\x84\x80\xe1\x85\xa1\xe1\x86\xa8",
		0,
		$rc);

	is(Net::LibIDN2::idn2_strerror_name($rc), "IDN2_NOT_NFC");
	is($result, undef);
}

{
	my $rc = 0;
	my $result = Net::LibIDN2::idn2_lookup_u8(
		"\x65\x78\x61\x6d\x70\x6c\x65\x2e\xe1\x84\x80\xe1\x85\xa1\xe1\x86\xa8",
		IDN2_NFC_INPUT,
		$rc);

	is(Net::LibIDN2::idn2_strerror_name($rc), "IDN2_OK");
	is($result, "example.xn--p39a");
}

{
	my $rc = 0;
	my $result = Net::LibIDN2::idn2_lookup_u8("xn--mli-x5ka8l.de", 0, $rc);

	is(Net::LibIDN2::idn2_strerror_name($rc), "IDN2_OK");
	is($result, "xn--mli-x5ka8l.de");
}

{
	local $TODO = "IDN2_ALABEL_ROUNDTRIP not implemented in 0.8 yet";

	my $rc = 0;
	my $result = Net::LibIDN2::idn2_lookup_u8("xn--mli-x5ka8l.de", IDN2_ALABEL_ROUNDTRIP, $rc);

	is(Net::LibIDN2::idn2_strerror_name($rc), "IDN2_UNKNOWN");
	is($result, undef);
}

{
	local $TODO = "IDN2_ALABEL_ROUNDTRIP not implemented in 0.8 yet";

	my $rc = 0;
	my $result = Net::LibIDN2::idn2_lookup_u8("xn--mli-5ka8l", IDN2_ALABEL_ROUNDTRIP, $rc);

	is(Net::LibIDN2::idn2_strerror_name($rc), "IDN2_OK");
	is($result, "xn--mli-5ka8l.de");
}

{
	my $result = Net::LibIDN2::idn2_register_u8("müßli");

	is($result, "xn--mli-5ka8l");
}

{
	my $result = Net::LibIDN2::idn2_register_u8("müßli", undef);

	is($result, "xn--mli-5ka8l");
}

{
	my $result = Net::LibIDN2::idn2_register_u8("müßli", undef, undef);

	is($result, "xn--mli-5ka8l");
}

{
	my $rc = 0;
	my $result = Net::LibIDN2::idn2_register_u8("müßli", undef, undef, $rc);

	is(Net::LibIDN2::idn2_strerror_name($rc), "IDN2_OK");
	is($result, "xn--mli-5ka8l");
}

{
	my $rc = 0;
	my $result = Net::LibIDN2::idn2_register_u8(
		"\xe1\x84\x80\xe1\x85\xa1\xe1\x86\xa8", 
		undef, 0, $rc);

	is(Net::LibIDN2::idn2_strerror_name($rc), "IDN2_NOT_NFC");
	is($result, undef);
}

{
	my $rc = 0;
	my $result = Net::LibIDN2::idn2_register_u8(
		"\xe1\x84\x80\xe1\x85\xa1\xe1\x86\xa8", 
		undef, IDN2_NFC_INPUT, $rc);

	is(Net::LibIDN2::idn2_strerror_name($rc), "IDN2_OK");
	is($result, "xn--p39a");
}

1;
