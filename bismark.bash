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
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e14/bismark
BISULFITE='SRR17281088 SRR17281087 SRR17281086 SRR17281085'

#initialize a csv of file names for each mates to pass to bismark for williams paired end files 
cd $SCRATCH/e14/trim_williams/

rm mates* 

touch mates_1.csv 
touch mates_2.csv 

for f in $BISULFITE 
	do 
	echo /global/scratch/users/chandlersutherland/e14/trim_williams/${f}_1_val_1.fq, >> mates_1.csv 
	echo /global/scratch/users/chandlersutherland/e14/trim_williams/${f}_2_val_2.fq, >> mates_2.csv
done 

#run bismark paired end for williams data
cd $BISMARK
./bismark --genome $ARAPORT11 --temp_dir $SCRATCH --output_dir $OUTPUT_DIR -p 4 -1 $SCRATCH/e14/trim_williams/mates_1.csv -2 $SCRATCH/e14/trim_williams/mates_2.csv

#run single end for 1001 genomes 
#./bismark --genome $ARAPORT11 --temp_dir $SCRATCH --output_dir $OUTPUT_DIR -p 4 /global/scratch/users/chandlersutherland/e14/bs_fastq_files/ecker/SRR771698.fastq
