#!/bin/bash
#SBATCH --job-name=simulate_experiment_runner
#SBATCH --account=ac_kvkallow
#SBATCH --partition=savio
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --time=01:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load r
module load r-packages

cd $SCRATC
Rscript /global/home/users/chandlersutherland/e14/simulate_experiment.r --no-save
