## Calculate inbreeding coefficients
```
perl aipl2ibc.pl genotypes.imputed ibc.txt kept-snp-list
```
kept-snp-list is a text file with single column listing 0-based indices of SNPs being **kept** for analysis.

## Convert AIPL files to PLINK files
```
perl aipl2plink.pl findhap-geno-folder ped-filename-prefix
```
