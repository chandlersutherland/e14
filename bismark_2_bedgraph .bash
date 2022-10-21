#!/bin/bash
#SBATCH --job-name=bismark_extractor
#SBATCH --partition=savio2
#SBATCH --qos=savio_lowprio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=01:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
source activate e14
module load samtools

OUTPUT_DIR=/global/scratch/users/chandlersutherland/e14/bismark/extraction/bedGraph

BISULFITE='SRR17281088 SRR17281087 SRR17281086 SRR17281085'
mkdir -p /global/scratch/users/chandlersutherland/e14/bismark/extraction/bedGraph/NLR_only/CpG_only

BISMARK_BEDGRAPH () {
    OUTPUT_DIR=/global/scratch/users/chandlersutherland/e14/bismark/extraction/bedGraph/NLR_only/CpG_only
	bismark2bedGraph --output $1.bed \
	--dir $OUTPUT_DIR \
	/global/scratch/users/chandlersutherland/e14/bismark/extraction/NLR_only/CpG_*$1*
    echo 'finished' $1
}

export -f BISMARK_BEDGRAPH

parallel BISMARK_BEDGRAPH ::: $BISULFITE
