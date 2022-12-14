#!/bin/bash
#SBATCH --job-name=methylation_py_runner
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --time=10:00:00
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out
cd $SCRATCH

module load python 
source activate e14

INPUT_DIR=$SCRATCH/e14/bismark/extraction

for f in $INPUT_DIR/*.txt
do 
	python $HOME/e14/methylation_coverage2.py $f
	echo 'finished' $f 

done 
