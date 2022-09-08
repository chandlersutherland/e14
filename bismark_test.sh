#!/bin/bash
#SBATCH --job-name=bismark_troubleshooting
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=04:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load bowtie2
module load samtools

BISMARK=/global/home/users/chandlersutherland/programs/Bismark-0.23.0
ARAPORT11=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e14/bismark/bismark_test
BISULFITE='SRR17281088 SRR17281087 SRR17281086 SRR17281085'
INPUT_DIR=/global/scratch/users/chandlersutherland/e14

cd $BISMARK

#test 1: do single end reads from williams improve mapping efficiency?
#test 1.1 on trim galore reads R2 directional 
#./bismark --genome $ARAPORT11 --temp_dir $SCRATCH --output_dir $OUTPUT_DIR -p 4 $INPUT_DIR/trim_williams/SRR17281085_2_val_2.fq

#R1 nondirectional 
./bismark --genome $ARAPORT11 --temp_dir $SCRATCH --output_dir $OUTPUT_DIR -p 4 --non_directional $INPUT_DIR/trim_williams/SRR17281085_1_val_1.fq

#R2 nondirectional
./bismark --genome $ARAPORT11 --temp_dir $SCRATCH --output_dir $OUTPUT_DIR -p 4 --non_directional $INPUT_DIR/trim_williams/SRR17281085_2_val_2.fq

#test 1.2 on not trimmed reads 
#./bismark --genome $ARAPORT11 --temp_dir $SCRATCH --output_dir $OUTPUT_DIR -p 4 $INPUT_DIR/bs_fastq_files/williams/SRR17281085_1.fastq

#test 2: was it my weird mates file input?
#./bismark --genome $ARAPORT11 --temp_dir $SCRATCH --output_dir $OUTPUT_DIR --non_directional -p 4 -1 $INPUT_DIR/trim_williams/SRR17281085_1_val_1.fq -2 $INPUT_DIR/trim_williams/SRR17281085_2_val_2.fq
