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

#define directory variables
INPUT=/global/scratch/users/chandlersutherland/e14/STAR_output/raw_sam
OUTPUT=/global/scratch/users/chandlersutherland/e14/STAR_output/htseq_count

HTCOUNT_RUN () {
    COUNTS_OUTPUT=/global/scratch/users/chandlersutherland/e14/STAR_output/htseq_count
    BASENAME=$(basename $1 _Aligned.out.sam)
    htseq-count -r pos -s yes -c $COUNTS_OUTPUT/${BASENAME}_NLRs.tsv $1 /global/scratch/users/chandlersutherland/Athaliana/GTFs/all_NLRs.gtf
    htseq-count -r pos -s yes -c $COUNTS_OUTPUT/${BASENAME}.tsv $1 /global/scratch/users/chandlersutherland/Athaliana/GTFs/Araport11_GTF_genes_transposons.current.gtf
    echo 'finished' ${BASENAME}
}

#apply STAR_RUN to the input files
export -f STAR_RUN
export -f HTCOUNT_RUN

#parallel STAR_RUN ::: $FILES 
#echo "finished STAR, moving on to htseq_counts" 

parallel HTCOUNT_RUN ::: $INPUT/*.sam
echo "finished HTCOUNT, ready for processing" 