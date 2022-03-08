## Calculate inbreeding coefficients
```
perl aipl2ibc.pl genotypes.imputed ibc.txt kept-snp-list
```
kept-snp-list is a text file with single column listing 0-based indices of SNPs being **kept** for analysis.

## Change genotypes 3/4 to 5 in findhap genotype files
```
perl change34to5.pl genotypes.imputed genotypes125.imputed kept-snp-list
```

## Convert AIPL files to PLINK files
```
perl aipl2plink.pl findhap-geno-folder ped-filename-prefix
```
