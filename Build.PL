# vim:set tabstop=4 shiftwidth=4 noexpandtab:

use strict;
use warnings;

use Module::Build;


my $build = Module::Build->new
(
	module_name => 'Net::LibIDN2',

	license  => 'perl',

	dist_author => 'Thomas Jacob <jacob@internet24.de>',

    dynamic_config       => 1,

	extra_compiler_flags => '',
	extra_linker_flags   => '-lidn2',

	build_requires =>
	{
		'ExtUtils::CBuilder' => 0,
		'ExtUtils::ParseXS' => 0,
		'Test::More' => '0.10',
	},
	
	requires =>
	{
		'perl' => '5.6.1',
	},
);
												    
$build->create_build_script;
