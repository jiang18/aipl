use warnings;
use strict;


@ARGV == 3 or die "3 arguments:\n  (1) trait.names file, (2)phenotype file, and (3) output filename prefix needed.\n";

my ($trait_names, $in,$out) = @ARGV;
unless(-e $trait_names)
{
	die "$trait_names not found.\n";
}

open IN,$trait_names;
my @traits;
while(<IN>)
{
	chomp;
	my $t = (split /\s+/)[1];
	((defined $t) and ($t ne '')) or next;
	push @traits,$t;
}
close IN;

my $rdiag_file = "$out.rdiag.csv";

open EMAT,">$rdiag_file";
print EMAT join(",","EGO",@traits),"\n";

open IN,$in;

open OUT,">$out.degressed.csv";

print OUT join(",","EGO",@traits),"\n";

my $nf = 0;
while(<IN>)
{
	chomp;
	my @c = split /\s+/;
	if($c[0] eq '') {shift @c};
	print EMAT $c[0];
	print OUT $c[0];

	for my $it (0..$#traits) 
	{
		my ($EBVlater,$PAlater,$RELlater,$RELPAlater) = @c[(4+$it*4)..(7+$it*4)];

		if ($RELlater >  $RELPAlater)
		{
                	my $DEprog = $RELlater / (100 - $RELlater) - $RELPAlater / (100 - $RELPAlater);
                	my $DEpa   = $RELPAlater / (100 - $RELPAlater);
                	my $regress1 = $DEprog / ($DEprog + $DEpa + 1);
                	my $regress = $DEprog / ($DEprog + 1);
                	my $DYD = $PAlater + ($EBVlater - $PAlater) / $regress1;

			print OUT ",$DYD";
			print EMAT ",",1/$regress-1;

		}
		else
		{
			print OUT ",";
			print EMAT ",";
			$nf ++;
		}
	}
	print OUT "\n";
	print EMAT "\n";
}
print "$nf phenotypic values have PTA=PA and therefore treated as missing in output.\n";
