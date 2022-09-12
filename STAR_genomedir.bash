#!/bin/bash
#SBATCH --job-name=STAR_genomedir 
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=00:10:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
source activate e14

#The s
GENOME_DIR_WILLIAMS=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/STAR_genome_williams
GENOME_DIR_ECKER=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/STAR_genome_ecker
FASTA_FILE=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/Athaliana_447_TAIR10.fa
GTF_FILE=/global/scratch/users/chandlersutherland/Athaliana/Araport11_GTF_genes_transposons.current.gtf

STAR --runThreadN $SLURM_NTASKS \
	 --runMode genomeGenerate \
	 --genomeDir $GENOME_DIR_WILLIAMS \
	 --genomeFastaFiles $FASTA_FILE \
	 --genomeSAindexNbases 12 \
	 --sjdbGTFfile $GTF_FILE  \
	 --sjdbOverhang 49

echo 'genome_dir_williams made' 

STAR --runThreadN $SLURM_NTASKS \
	 --runMode genomeGenerate \
	 --genomeDir $GENOME_DIR_ECKER \
	 --genomeFastaFiles $FASTA_FILE \
	 --genomeSAindexNbases 12 \
	 --sjdbGTFfile $GTF_FILE  \
	 --sjdbOverhang 99

echo 'genome_dir_ecker made' 