# match control SNPs using local SNPsnap database and algorithm adapted from SNPsnap paper

The code was originally written for members of Xin He lab at UChicago to run SNPsnap locally on UChicago RCC compute cluster, 
without having to use the SNPsnap web server.

The SNPsnap database was downloaded from the [SNPsnap website](http://www.broadinstitute.org/mpg/snpsnap/match_snps.html).
The database file (`ld0.5_collection`) of European population can also be downloaded [here](https://uchicago.box.com/s/x7v0eg62zvyz2tw1f460iyrajqgcjlw1).

## R packages required
```
library(optparse)
library(foreach)
library(doParallel)
```

## Example setting in match_snps_snpsnap_batches.R
```
# filename_input <- "/project2/xinhe/kevinluo/SNPsnap/test/test_input.txt"
# dir_out <- "/project2/xinhe/kevinluo/SNPsnap/test/"
# population <- "EUR"
# num_matching_snps <- 100
# thresh_MAF <- 0.05
# thresh_dist2gene <- 0.5
# thresh_ld_friends <- 0.5
# thresh_gene_density <- 0.5
# num_batches <- 3
# idx_batch <- 1
```

## slurm code on U Chicago RCC compute cluster
```
inputfile=/project2/xinhe/kevinluo/SNPsnap/test/test_input.txt
dir_out=/project2/xinhe/kevinluo/SNPsnap/test/
num_matching_snps=100
num_batches=5 # split SNPs into batches for slurm batch array

## do not split into batches
sbatch --array=1 --mem=30G --ntasks-per-node=5 /project2/xinhe/kevinluo/SNPsnap/code/match_snps_snpsnap_batcharray.sbatch ${inputfile} ${dir_out} ${num_matching_snps} EUR 1

## split into batches
sbatch --array=1-${num_batches} --mem=30G --ntasks-per-node=5 /project2/xinhe/kevinluo/SNPsnap/code/match_snps_snpsnap_batcharray.sbatch ${inputfile} ${dir_out} ${num_matching_snps} EUR ${num_batches}

cd ${dir_out}/matched_SNPs/test_input_${num_batches}batches

cat SNPmatch_100_matchedSNPs_batch*.txt | gzip > SNPmatch_100_matchedSNPs.txt.gz
```

## Output format
The file named “SNPmatch_*_matchedSNPs.txt” has a table of input SNPs and matched SNPs. The first column contains the input SNPs, the second is the number of SNPs in the SNPsnap database satisfied our thresholds, the following columns are matching SNPs sampled from the SNPsnap database that satisfied our thresholds.

The file named “snpsnap_input_exist.txt” saved the information for the SNPs that exist in the database.

The file named “unincluded_snps.txt” show the SNPs that are not exist in the database.
