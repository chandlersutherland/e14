#!/bin/bash
#SBATCH --job-name=deeptools 
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --time=00:20:00
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

SAMPLE='SRR17281085'

module load python/3.8.8
source activate e14_deeptools
#first, need to remove the track line from the bedgraph files, and save them as *.fixed.bed 
INPUT_DIR=/global/scratch/users/chandlersutherland/e14/bismark/extraction/bedGraph/
grep -v track ${INPUT_DIR}/${SAMPLE}.bed > ${INPUT_DIR}/${SAMPLE}.fixed.bed

#now, convert to bigwig 
CHROM_SIZE=$SCRATCH/e14/deeptools/Athaliana_447_TAIR10.genome.sizes
bedGraphToBigWig ${INPUT_DIR}/${SAMPLE}.fixed.bed $CHROM_SIZE $SCRATCH/e14/bismark/extraction/bigwig/${SAMPLE}.bw

conda deactivate
module purge 

#ok, now to do some profile plots 
module load python 
source activate e14 

density_file=/global/scratch/users/chandlersutherland/e14/bismark/extraction/bigwig/${SAMPLE}.bw 
THREADS=$SLURM_NTASKS
HV_BED=/global/home/users/chandlersutherland/e14/data/hv_NLR.bed
NONHV_BED=/global/home/users/chandlersutherland/e14/data/nonhv_NLR2.bed
DEEPTOOLS_DIR=$SCRATCH/e14/deeptools

#first, compute hv with the density file (bw file) 
computeMatrix scale-regions -p $THREADS -S $density_file \
							-R ${HV_BED} \
							--regionBodyLength 4000 \
							-o ${DEEPTOOLS_DIR}/${SAMPLE}.hv.mat.gz 

computeMatrix scale-regions -p $THREADS -S $density_file \
							-R ${NONHV_BED} \
							--regionBodyLength 4000 \
							-o ${DEEPTOOLS_DIR}/${SAMPLE}.nhv.mat.gz 
							
plotProfile -m ${DEEPTOOLS_DIR}/${SAMPLE}.hv.mat.gz \
			-out ${SAMPLE}.hv.pdf \
			--numPlotsPerRow 1 
			--plotTitle "${SAMPLE}" HV \
			--outFileNameData ${DEEPTOOLS_DIR}/${SAMPLE}.hv.tab 
			
plotProfile -m ${DEEPTOOLS_DIR}/${SAMPLE}.nhv.mat.gz \
			-out ${SAMPLE}.nhv.pdf \
			--numPlotsPerRow 1 
			--plotTitle "${SAMPLE}" NHV \
			--outFileNameData ${DEEPTOOLS_DIR}/${SAMPLE}.nhv.tab 
