#!/bin/bash

#SBATCH --job-name=NSC20_matchSNPs
#SBATCH --output=NSC20_matchSNPs_%A_%a.out
#SBATCH --error=NSC20_matchSNPs_%A_%a.err
#SBATCH --time=36:00:00
#SBATCH --partition=bigmem2
#SBATCH --account=pi-xinhe
#SBATCH --mem-per-cpu=32G
#SBATCH --nodes=1
#SBATCH --ntasks=5
#SBATCH --array=1-5

# --ntasks-per-node will be used in doParallel.R to specify the number
# of cores to use on the machine.

## parameters
idx_batch=$(($SLURM_ARRAY_TASK_ID))

filename_input=/project2/xinhe/kevinluo/neuron_ATACseq/SNPsnap/from_Siming/NSC_20_ASoC_FDR0.05/NSC_20_ASoC_FDR0.05.bed.chrpos.hg19.txt
dir_out=/project2/xinhe/kevinluo/neuron_ATACseq/SNPsnap/from_Siming/NSC_20_ASoC_FDR0.05
num_matching_snps=100
population=EUR
num_batches=5
thresh_dist2gene=1000
thresh_gene_density=100

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
  --num_matching_snps ${num_matching_snps} \
  --thresh_dist2gene ${thresh_dist2gene} \
  --thresh_gene_density ${thresh_gene_density}


