#!/bin/bash
#SBATCH --job-name=vcf_thin
#SBATCH --partition=savio4_htc
#SBATCH --qos=minium_htc4_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=01:00:00 
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load vcftools
cd /global/scratch/users/chandlersutherland/e14/popgen/vcf_1001

vcftools --vcf 1001genomes_snp-short-indel_only_ACGTN.vcf --keep nlrome_IDs.txt --recode --recode-INFO-all --out nlrome_partial 


