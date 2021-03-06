# calculate inbreeding coefficients using AIPL genotypes
# similar to VanRaden GRM 1 but allele frequency fixed to 0.5
# missing genotypes excluded
# use a pre-specified list of 0-based SNP indices for QC

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
print OUT "anim\tibc\tgood_markers\n";
while(<IN>)
{
	chomp;
	my @c = split /\s+/;
	my $anim;
	if($c[0] eq '') {
		$anim = $c[1];
	} else {
		$anim = $c[0];
	}
	
	my @gg = (split //,$c[-1])[@subset];
	my $ibc = 0;
	my $nm = 0;
	for my $g (@gg) {
		next if ($g > 2);
		$g -= 1;
		$ibc += $g*$g;
		$nm ++;
	}
	$ibc = $ibc / (0.5*$nm) - 1;
	print OUT "$anim\t$ibc\t$nm\n";
	
	$num_processed ++;
	
	if($num_processed % 1000 == 0) {
		print "$num_processed animals processed\n";
	}
}
close IN;
close OUT;

