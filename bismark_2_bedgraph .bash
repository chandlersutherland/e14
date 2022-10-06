#!/bin/bash
#SBATCH --job-name=bismark_extractor
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
module load samtools

BISMARK=/global/home/users/chandlersutherland/programs/Bismark-0.23.0
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e14/bismark/extraction/bedGraph

#already ran SRR17281088 in interactive to test, so don't need it here 
BISULFITE='SRR17281088 SRR17281087 SRR17281086 SRR17281085'

cd $BISMARK 

#williams time 
for f in $BISULFITE
do 
	./bismark2bedGraph -p \
		--output  $f.bed \
		--CX_context \
		/global/scratch/users/chandlersutherland/e14/bismark/extraction/NLR_only/*$f*
	echo "finished" $f 
done

