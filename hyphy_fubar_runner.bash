#!/bin/bash
#SBATCH --job-name=hyphy_fubar
#SBATCH --partition=savio4_htc
#SBATCH --qos=minium_htc4_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=24:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python
module load parallel 
source activate e14 

base=/global/scratch/users/chandlersutherland/e14/popgen/clades
output_csv=/global/scratch/users/chandlersutherland/e14/popgen/hyphy_fubar.csv
clade=$(cat /global/scratch/users/chandlersutherland/e14/popgen/clades.txt)
echo "Clade,n_codons,n_pos_sites" > $output_csv

FUBAR_RUN(){
	alignment=${base}/${clade}/popgenome/${clade}.pal2nal.fas
	tree=${base}/${clade}/RAxML*.out
	
	log_file=${base}/${clade}/hyphy_fubar.log
	echo "Running Hyphy on $clade"
	
	#actually run hyphy in multithreading mode to hopefully speed up 
	hyphy  fubar CPU=24 --alignment ${alignment} --tree ${tree} | tee -a $log_file
	
	#parse out relevant values  
	n_sites=$(grep 'FUBAR inferred' hyphy_fubar.log | sed 's@^[^0-9]*\([0-9]\+\).*@\1@') 
	n_codons=$(grep 'Loaded a multiple sequence alignment' hyphy_fubar.log | sed -r 's/([^0-9]*([0-9]*)){2}.*/\2/')
	
	#write to csv with clade info 
	echo "${clade},${n_codons},${n_sites}" >> $output_csv
	echo "finished $clade"
}

export base=$base
export output_csv=$output_csv 
export -f FUBAR_RUN

parallel FUBAR_RUN ::: $clade 

#for each clade, identify the codon alignment file and tree, then run hyphy busted
#while read clade
#do 
	#name inputs 
#	alignment=${base}/${clade}/popgenome/${clade}.pal2nal.fas
#	tree=${base}/${clade}/RAxML*.out
	
#	log_file=${base}/${clade}/hyphy_busted.log
#	echo "Running Hyphy on $clade"
	
	#actually run hyphy in multithreading mode to hopefully speed up 
#	hyphy  busted CPU=24 --alignment ${alignment} --tree ${tree} | tee -a $log_file
	
	
	#parse out p value  
#	p=$(grep 'Likelihood ratio test' $log_file | grep -Eo '[+-]?[0-9]+([.][0-9]+)?') 
	
	#write to csv with clade info 
#	echo "${clade},${p}" >> $output_csv
#	echo "finished $clade"
#done < /global/scratch/users/chandlersutherland/e14/popgen/clades.txt 
