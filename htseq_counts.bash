#!/bin/bash
#SBATCH --job-name=htseq_counts 
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=02:40:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
source activate e14

INPUT=/global/scratch/users/chandlersutherland/e14/STAR_output/NLR_bam
OUTPUT=/global/scratch/users/chandlersutherland/e14/STAR_output/htseq_count


cd $INPUT 

for f in *.bam
do 
	BASENAME=$(basename $f _Aligned.out_NLRs.bam) 
	htseq-count -r pos -s yes -c $OUTPUT/${BASENAME}_NLRs.tsv $f /global/scratch/users/chandlersutherland/Athaliana/GTFs/all_NLRs.gtf
	echo 'finished' ${BASENAME} 
done
echo 'finished!'

