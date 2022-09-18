#!/bin/bash
#SBATCH --job-name=nlr_filter
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --time=00:20:00
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load samtools
module load python 

source activate e14

BISMARK=/global/home/users/chandlersutherland/programs/Bismark-0.23.0
OUTPUT_DIR=/global/scratch/users/chandlersutherland/e14/bismark/extraction

#first, define a function nlr_sort to quickly sort and filter by NLRs 
nlr_sort (){
	BASENAME=$(basename $1 .bam)
	samtools sort $1 |\
	samtools view -b -h -P -L $HOME/e14/data/all_NLR.bed |\
	samtools sort -n -o $SCRATCH/e14/bismark/NLR_bam/${BASENAME}_NLR.bam	
}

export -f nlr_sort
parallel nlr_sort {} ::: $SCRATCH/e14/bismark/deduplicate_bismark/*.bam

#now run the methylation extractor, with specific schemes for ecker and williams 
BISULFITE='SRR17281088 SRR17281087 SRR17281086 SRR17281085'

cd $BISMARK 
for f in $BISULFITE
do 
	./bismark_methylation_extractor -p \
		--output  $OUTPUT_DIR \
		--ignore_r2 2 \
		--comprehensive \
		--parallel $SLURM_NTASKS \
		/global/scratch/users/chandlersutherland/e14/bismark/NLR_bam/${f}_1_val_1_bismark_bt2_pe.deduplicated_NLR.bam
	echo "finished" $f 
done 

./bismark_methylation_extractor -s \
		--output  $OUTPUT_DIR \
		--comprehensive \
		--parallel $SLURM_NTASKS \
		/global/scratch/users/chandlersutherland/e14/bismark/NLR_bam/SRR771698_bismark_bt2.deduplicated_NLR.bam