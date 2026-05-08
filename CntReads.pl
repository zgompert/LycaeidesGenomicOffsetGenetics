#!/usr/bin/perl
#
# get number of reads from bam files
#

open(IN,"bams") or die;
while(<IN>){
	chomp;
	system "samtools flagstat $_ | head -n 1 | cut -f 1 -d \" \" >> reads.txt\n";
}
close(IN);

