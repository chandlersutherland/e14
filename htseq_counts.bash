#!/bin/bash
#SBATCH --job-name=htseq_counts 
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=03:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
source activate e14

INPUT=/global/scratch/users/chandlersutherland/e14/STAR_output/sort_index
OUTPUT=/global/scratch/users/chandlersutherland/e14/STAR_output/htseq_count


cd $INPUT 

#for f in *.bam
f='SRR17281233_Aligned.out.bam'
#do 
	BASENAME=$(basename $f _Aligned.out.bam) 
	htseq-count -r pos -s yes $f /global/scratch/users/chandlersutherland/Athaliana/Araport11_GTF_genes_transposons.current.gtf

#done
echo 'finished!' 
