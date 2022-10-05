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

#this script passes a bam file to the python script samtools_coverage, which outputs a file $BASENAME_clean_coverage.tsv which gives the mean depth over the NLRs
#can easily be made into a for loop to pass multiple files through 

module load python
module load samtools/1.14
#very important to have this version 
INPUT=/global/scratch/users/chandlersutherland/e14/polyester/primary_simulated_reads_1004/STAR

cd $INPUT

for file in *.sam
do 
	BASENAME=$(basename ${file} .sam)
	echo $BASENAME
	#first, convert to bam, sort and index for samtools coverage to run appropriately 
	samtools view -@ $SLURM_NTASKS -b $file |\
	samtools sort -@ 20 - -o $INPUT/sort_index/${BASENAME}.bam
	samtools index $INPUT/sort_index/${BASENAME}.bam
done 

cd $INPUT/sort_index/

for file in *.bam 
do 
	#run the coverage file 
	python $HOME/e14/samtools_coverage.py ${file}
done 

#clean up working directory 
mv *_clean_coverage.tsv $INPUT/coverage
rm *coverage.tsv 

#fun fun python?



#filter bam file by just NLRs, sort and index for IGV  
cd $INPUT/sort_index/
#untested 
for file in *.bam
do 
	BASENAME=$(basename ${file} .bam)
	samtools view -b -h -L $HOME/e14/data/all_NLR.bed $file |\
	samtools sort -@ 20 - -o $INPUT/NLR_bam/${BASENAME}_NLRs.bam 
	samtools index $INPUT/NLR_bam/${BASENAME}_NLRs.bam
	
done 
