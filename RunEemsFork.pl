#!/usr/bin/perl
#
# run eems jobs
#

use Parallel::ForkManager;
my $max = 20;
my $pm = Parallel::ForkManager->new($max);

$i=1;
foreach $in (@ARGV){
	$i++;
	$pm->start and next; ## fork
	$sd = $i*100;
	system "~/source/eems/runeems_snps/src/runeems_snps --params $in --seed $sd\n";
	$pm->finish;
}

$pm->wait_all_children;



