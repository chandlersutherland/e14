#!/bin/bash
#SBATCH --job-name=RSEM_test
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=00:40:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
module load RSEM 

source activate e14

ARAPORT11_FA=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa
GTF_FILE=/global/scratch/users/chandlersutherland/Athaliana/GTFs/Araport11_GTF_genes_transposons.current.gtf
FASTQ_FILE=/global/scratch/users/chandlersutherland/e14/rna_fastq_files/williams/SRR17281233.fastq
GFF3=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_Araport11.gene_exons.gff3

rsem-prepare-reference --gff3 $GFF3 --bowtie --bowtie-path ~/.conda/envs/ecd14/bin/ $ARAPORT11_FA araport11

rsem-calculate-expression $FASTQ_FILE araport11 SRR17281233 
