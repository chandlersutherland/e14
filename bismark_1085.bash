#!/bin/bash
#SBATCH --job-name=bismark_deduplicate
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=02:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load bowtie2
module load samtools

BISMARK=/global/home/users/chandlersutherland/programs/Bismark-0.23.0
ARAPORT11=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e14/bismark
INPUT_DIR=/global/scratch/users/chandlersutherland/e14

cd $BISMARK 
./bismark --genome $ARAPORT11 \
	--temp_dir $SCRATCH \
	--output_dir ${OUTPUT_DIR}/bam_files \
	--non_directional -p 4 \
	-1 $INPUT_DIR/trim_williams/SRR17281085_1_val_1.fq \
	-2 $INPUT_DIR/trim_williams/SRR17281085_2_val_2.fq
	
./deduplicate_bismark -p \
	--output_dir  $SCRATCH/e14/bismark/deduplicate_bismark/ \
	/global/scratch/users/chandlersutherland/e14/bismark/bam_files/SRR17281085_1_bismark_bt2_pe.bam