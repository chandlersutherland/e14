#!/bin/bash
#SBATCH --job-name=hyphy_w
#SBATCH --partition=savio4_htc
#SBATCH --qos=minium_htc4_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=01:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
source activate e14 

base=/global/scratch/users/chandlersutherland/e14/popgen/clades
output_file=/global/scratch/users/chandlersutherland/e14/popgen/hyphy_w.log
#for each clade, identify the alignment file, then run pal2nal with the transcript fasta file. 
while read clade
do 
	#name inputs 
	alignment=${base}/${clade}/popgenome/${clade}.pal2nal.fas
	tree=${base}/${clade}/RAxML*.out
	echo 'Running Hyphy on $clade'
	
	cat $clade >> $output_file
	#actually run hyphy
	(echo "5"; echo "1"; echo "1"; echo ${alignment}; echo "MG94CUSTOMCF3X4"; echo "2"; echo "012345"; echo ${tree}; echo "1") | hyphy -i | grep -A 8 RESULTS >> $output_file
	
	echo "finished $clade"
done < ${base}/clades.txt 