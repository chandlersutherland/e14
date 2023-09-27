#!/bin/bash
#SBATCH --job-name=hyphy_busted
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
output_csv=/global/scratch/users/chandlersutherland/e14/popgen/hyphy_busted_internal_p.csv
clade=$(cat /global/scratch/users/chandlersutherland/e14/popgen/clades.txt)

echo "Clade,p" > $output_csv

BUSTED_RUN(){
	alignment=${base}/${1}/popgenome/${1}.pal2nal.fas
	tree=${base}/${1}/RAxML*.out
	log_file=${base}/${1}/hyphy_busted_internal.log
	
	echo "Running Hyphy on $1"
	hyphy  busted CPU=24 --alignment ${alignment} --tree ${tree} --branches Internal | tee -a ${log_file}
	
	p=$(grep 'Likelihood ratio test' $log_file | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
	
	echo "${1},${p}" >> $output_csv
	echo "finished $1"
	
}

export base=$base
export output_csv=$output_csv 
export -f BUSTED_RUN

parallel BUSTED_RUN ::: $clade 

#echo "Clade,p" > $output_csv

#for each clade, identify the codon alignment file and tree, then run hyphy busted
#while read clade
#do 
	#name inputs 
	#alignment=${base}/${clade}/popgenome/${clade}.pal2nal.fas
	#tree=${base}/${clade}/RAxML*.out
	
#	log_file=${base}/${clade}/hyphy_busted_internal.log
#	echo "Running Hyphy on $clade"
#	
	#actually run hyphy in multithreading mode to hopefully speed up 
#	hyphy  busted CPU=24 --alignment ${alignment} --tree ${tree} --branches Internal | tee -a $log_file
	
	
	#parse out p value  
#	p=$(grep 'Likelihood ratio test' $log_file | grep -Eo '[+-]?[0-9]+([.][0-9]+)?') 
	
	#write to csv with clade info 
##	echo "finished $clade"
#done < /global/scratch/users/chandlersutherland/e14/popgen/clades3.txt 