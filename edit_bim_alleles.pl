use strict;
use warnings;

@ARGV ==3 or die "3 files needed: coding-file, old-bim, new-bim\n";

my ($coding, $bim1, $bim2) = @ARGV;

my %pos_a1;
my %pos_a2;
open IN,$coding;
$_=<IN>;
while(<IN>) {
	my @c =split /,/;
  $c[-1] =~ s/\r//g;
	chomp $c[-1];
	next if($c[-1] eq 'Not useful');
	$pos_a1{$c[0]} = $c[2];
	$pos_a2{$c[0]} = $c[4];
}
close IN;

open IN,$bim1;
open OUT,">$bim2";
while(<IN>) {
	chomp;
	my @c =split /\s+/;
 
  if(defined $pos_a1{$c[3]}) {
  	if($c[4] eq '1') {
  		$c[4] = $pos_a1{$c[3]};
  	} elsif ($c[4] eq '2') {
  		$c[4] = $pos_a2{$c[3]};
  	}
    if($c[5] eq '1') {
  		$c[5] = $pos_a1{$c[3]};
  	} elsif ($c[5] eq '2') {
  		$c[5] = $pos_a2{$c[3]};
  	}
  	print OUT join "\t",@c;
  	print OUT "\n";
  } else {
    print STDERR "Missing in $coding:\n    $_\n";
    print OUT "$_\n";
  }
}
close IN;
close OUT;

