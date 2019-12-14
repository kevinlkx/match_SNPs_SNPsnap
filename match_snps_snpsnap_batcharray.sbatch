#!/bin/bash

#SBATCH --job-name=matchSNPs_batches
#SBATCH --output=matchSNPs_batches_%A_%a.out
#SBATCH --error=matchSNPs_batches_%A_%a.err
#SBATCH --partition=broadwl
#SBATCH --mem=30G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=5

# --ntasks-per-node will be used in doParallel.R to specify the number
# of cores to use on the machine.

## parameters
idx_batch=$(($SLURM_ARRAY_TASK_ID))

filename_input=$1
dir_out=$2
num_matching_snps=$3
population=$4
num_batches=$5

module load R/3.5.1

dir_code=/project2/xinhe/kevinluo/SNPsnap/code

echo "Input file: ${filename_input}"
echo "Directory output: ${dir_out}"

echo "Batch #${idx_batch} out of ${num_batches} batches."

Rscript ${dir_code}/match_snps_snpsnap_batches.R \
  --input_file ${filename_input} \
  --dir_out ${dir_out} \
  --num_batches ${num_batches} \
  --idx_batch ${idx_batch} \
  --population ${population} \
  --num_matching_snps ${num_matching_snps}


