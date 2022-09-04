#!/bin/bash
#SBATCH --job-name=coverage_py_runner
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python
module load samtools/1.14
#very important to have this version 

cd $SCRATCH/e14/bismark

echo 'rname  startpos        endpos  numreads        covbases        coverage        meandepth       meanbaseq       meanmapq' > coverage.tsv 

python $HOME/e14/samtools_coverage.py 

sed '/^#/d' coverage.tsv > coverage.tsv 

