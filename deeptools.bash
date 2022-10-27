#!/bin/bash
#SBATCH --job-name=deeptools 
#SBATCH --partition=savio2
#SBATCH --qos=savio_lowprio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --time=00:20:00
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load parallel 

plotter() {
	module load python/3.8.8
	source activate e14_deeptools
	#first, need to remove the track line from the bedgraph files, and save them as *.fixed.bed 
	INPUT_DIR=/global/scratch/users/chandlersutherland/e14/deeptools/cpg_highcov
	#grep -v track ${INPUT_DIR}/${1}.bed > ${INPUT_DIR}/${1}.fixed.bed

	#now, convert to bigwig 
	CHROM_SIZE=$SCRATCH/e14/deeptools/Athaliana_447_TAIR10.genome.sizes
	mkdir -p $SCRATCH/e14/deeptools/cpg_highcov/bigwig/
	sort -k1,1 -k2,2n ${INPUT_DIR}/${1}_cpg_highcov.bed > ${INPUT_DIR}/${1}_cpg_highcov_sorted.bed
	bedGraphToBigWig ${INPUT_DIR}/${1}_cpg_highcov_sorted.bed $CHROM_SIZE $SCRATCH/e14/deeptools/cpg_highcov/bigwig/${1}.bw
	
	echo 'converted ${1} to bigwig' 
	
	conda deactivate
	module purge 

	#ok, now to do some profile plots 
	module load python 
	source activate e14 

	density_file= $SCRATCH/e14/deeptools/cpg_highcov/bigwig/${1}.bw
	THREADS=$SLURM_NTASKS
	HV_BED=/global/home/users/chandlersutherland/e14/data/hv_NLR.bed
	NONHV_BED=/global/home/users/chandlersutherland/e14/data/nonhv_NLR2.bed
	DEEPTOOLS_DIR=$SCRATCH/e14/deeptools/cpg_highcov
	mkdir -p $DEEPTOOLS_DIR
	
	#not currently working on interactive mode, but no error messages?
	computeMatrix scale-regions -S $SCRATCH/e14/deeptools/cpg_highcov/bigwig/${1}.bw \
		-R ${HV_BED} ${NONHV_BED} \
		--regionBodyLength 4000 \
		-o ${DEEPTOOLS_DIR}/${1}.both.mat.gz
	
	plotProfile -m ${DEEPTOOLS_DIR}/${1}.both.mat.gz \
		-out ${DEEPTOOLS_DIR}/${1}.both.pdf \
		--numPlotsPerRow 2 \
		--plotTitle "${1}" \
		--outFileNameData ${DEEPTOOLS_DIR}/${1}.both.tab 
		
	echo 'finished' ${1}
}

export -f plotter

BISULFITE='SRR17281087 SRR17281086 SRR17281088 SRR17281085'
parallel plotter ::: $BISULFITE

echo 'parallel finished'
