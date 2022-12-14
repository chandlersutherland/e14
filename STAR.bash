#!/bin/bash
#SBATCH --job-name=STAR
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=00:12:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
source activate e14

GENOME_DIR_WILLIAMS=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/STAR_genome_williams
GENOME_DIR_ECKER=/global/scratch/users/chandlersutherland/phytozome/Athaliana/Araport11/assembly/STAR_genome_ecker
ECKER=/global/scratch/users/chandlersutherland/e14/rna_fastq_files/ecker
WILLIAMS=/global/scratch/users/chandlersutherland/e14/rna_fastq_files/williams
WILLIAMS_TRIMMED=/global/scratch/users/chandlersutherland/e14/trim_williams/rna
OUTPUT=/global/scratch/users/chandlersutherland/e14/STAR_output

#start with ecker 
#STAR --runThreadN $SLURM_NTASKS --genomeDir $GENOME_DIR_ECKER --outFileNamePrefix $OUTPUT/SRR3465232_ --readFilesIn $ECKER/SRR3465232_1.fastq $ECKER/SRR3465232_2.fastq

#echo 'ecker finished'

#move to williams 


echo 'starting williams'
#didn't work, need to create basename variable in for loop for output prefix 
RNA='SRR17281233  SRR17281234  SRR17281235  SRR17281236'

#cd $WILLIAMS
#for file in $RNA
#do 
#	BASENAME=$(basename $file .fastq)
#	STAR --runThreadN $SLURM_NTASKS --genomeDir $GENOME_DIR_WILLIAMS --outFileNamePrefix "${OUTPUT}"/"${BASENAME}"_ --readFilesIn ${file}.fastq
#done 

echo 'finished!' 

cd $WILLIAMS_TRIMMED
for file in $RNA
do 
	BASENAME=$(basename $file)
	STAR --runThreadN $SLURM_NTASKS --genomeDir $GENOME_DIR_WILLIAMS --outFileNamePrefix "${OUTPUT}"/"${BASENAME}"_trimmed_ --readFilesIn ${file}_trimmed.fq
done 

echo 'finished!' 
