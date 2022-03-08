# change genotypes 3/4 to 5 in FINDHAP genotypes.filled.

use strict;
use warnings;

@ARGV == 3 or die "Two arguments needed: aipl-geno-filename, output-filename, and kept-snp-list\n";
my ($aipl, $out, $kept) = @ARGV;

my @subset;
open IN,$kept or die "Could not open $kept: $!\n";
while(<IN>) {
	if(/\d+/) {
		push @subset, $&;
	}
}
close IN;
@subset = sort {$a <=> $b} @subset;

my $num_processed = 0;
open IN,$aipl or die "Could not open $aipl: $!\n";
open OUT,">$out";
while(<IN>)
{
	chomp;
	my @c = split /\s+/;
	
	my @gg = (split //,$c[-1])[@subset];
	$c[-1] = join "",@gg;
	$c[-1] =~ s/3|4/5/g;
	
	print OUT join("\t", @c),"\n";
	
	$num_processed ++;
	if($num_processed % 1000 == 0) {
		print "$num_processed animals processed\n";
	}
}
close IN;
close OUT;
