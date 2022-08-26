#!/bin/bash
#SBATCH --job-name=trim_galore
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=02:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load cutadapt
module load fastqc 

TRIM_DIR=/global/home/users/chandlersutherland/programs/TrimGalore-0.6.6
OUT_DIR=/global/scratch/users/chandlersutherland/e14/trim_williams
bisulfite='SRR17281088 SRR17281087 SRR17281086 SRR17281085'

cd /global/scratch/users/chandlersutherland/e14/bs_fastq_files/williams/

for f in $bisulfite
do 
   $TRIM_DIR/trim_galore -o $OUT_DIR --fastqc --illumina --paired_file "${f}"_1.fastq "${f}"_2.fastq
done 