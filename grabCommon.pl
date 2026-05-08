#!/usr/bin/perl
#
# subset to common, randomly sampled SNPs for entropy
#

open(IN,"mafKeep.txt") or die;
while(<IN>){
	chomp;
	push(@keep,$_);
}
close(IN);

open(IN,"lyc_goff.gl") or die;
open(OUT, "> sub_lyc_goff.gl") or die "failed to write\n";

foreach $i (0..1){
	$hdr = <IN>;
	print OUT $hdr;
}

## main bit
while(<IN>){
	$a = shift(@keep);
	if($a == 1){
		print OUT $_;
	}
}
close(IN);
close(OUT);
