#!/usr/bin/perl
#
# run estpEM for each population
#

open(IN,"files.txt") or die;

while(<IN>){
	chomp;
	m/^([A-Z]+)/ or die "failed here: $_\n";
	$out = "p_$1.txt";
	system "estpEM -i $_ -o $out -e 0.001 -m 50 -h 2\n";
}
close(IN);
