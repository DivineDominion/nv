#!/usr/bin/perl

use	Text::Textile qw(textile);

my $text;
{
	local $/;               # Slurp the whole file
	$text = <>;
}
print textile($text);