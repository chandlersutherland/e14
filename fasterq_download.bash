#!/bin/bash
#SBATCH --job-name=fastq_download
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=03:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

## download the sra files for epigenomes and rnaseq 

module load python
module load sra-tools

#download williams data 
bisulfite='SRR17281073 SRR17281074 SRR17281075 SRR17281076'
rna='SRR17281222 SRR17281223 SRR17281224'

for i in $bisulfite
	do 
	fasterq-dump --threads $SLURM_NTASKS -O $SCRATCH_DIR/bs_fastq_files/williams_drdd -t $SCRATCH_DIR -p $i
done 

echo "finished williams bisulfite, beginning RNA"

for i in $rna
	do 
	fasterq-dump --threads $SLURM_NTASKS -O $SCRATCH_DIR/rna_fastq_files/williams_drdd -t $SCRATCH_DIR -p $i
done
