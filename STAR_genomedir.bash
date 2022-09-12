#!/bin/bash
#SBATCH --job-name=STAR_genomedir 
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=01:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
source activate e14

GENOME_DIR=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/STAR_genome
FASTA_FILE=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa
GFF3_FILE=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_Araport11.gene_exons.gff3

STAR --runThreadN $SLURM_NTASKS --runMode genomeGenerate --genomeDir $GENOME_DIR --genomeFastaFile $FASTA_FILE --sjdbGTFtagExonParentTranscript $GFF3_FILE 

print('genome_dir made') 
