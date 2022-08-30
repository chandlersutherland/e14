#!/bin/bash
#SBATCH --job-name=bismark
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=06:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load bowtie2
module load samtools

BISMARK=/global/home/users/chandlersutherland/programs/Bismark-0.23.0
ARAPORT11=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly

cd $SCRATCH
for f in /global/scratch/users/chandlersutherland/e14/trim_williams/*.fq
	do
	.$BISMARK/bismark --genome $ARAPORT11  $f 
done

.$BISMARK/bismark --genome $ARAPORT11 /global/scratch/users/chandlersutherland/e14/bs_fastq_files/ecker/SRR771698.fastq
