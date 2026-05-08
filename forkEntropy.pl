#!/usr/bin/perl
# fork script for entropy 

use Parallel::ForkManager;
my $max = 18;
my $pm = Parallel::ForkManager->new($max);


foreach $k (2..3){
	foreach $ch (0..8){ 
		sleep 2;
		$pm->start and next;
		$out = "out_k$k"."_ch$ch".".hdf5";
		system "entropy -i ../Variants/sub_lyc_goff.gl -w 0 -m 1 -l 2000 -b 1000 -t 5 -k $k -o $out -q ldak$k".".txt -s 20\n";
		$pm->finish;
	}
}
$pm->wait_all_children;


