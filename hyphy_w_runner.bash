#!/bin/bash
#SBATCH --job-name=hyphy_w
#SBATCH --partition=savio4_htc
#SBATCH --qos=minium_htc4_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=03:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
source activate e14 

base=/global/scratch/users/chandlersutherland/e14/popgen/clades
output_file=/global/scratch/users/chandlersutherland/e14/popgen/hyphy_w.csv
#echo "Clade,R,log_likelihood,GT,CT,CG,AT,AC" > $output_file

#for each clade, identify the codon alignment file and tree, then run hyphy to calculate dn/ds
while read clade
do 
	#name inputs 
	alignment=${base}/${clade}/popgenome/${clade}.pal2nal.fas
	tree=${base}/${clade}/RAxML*.out
	echo "Running Hyphy on $clade"
	
	#cat echo ${clade} >> $output_file
	#actually run hyphy
	results=$((echo "5"; echo "1"; echo "1"; echo ${alignment}; echo "MG94CUSTOMCF3X4"; echo "2"; echo "012345"; echo ${tree}; echo "1") | hyphy -i | grep -A 8 RESULTS)
	
	#parse out desired info 
	R=$(echo $results | tr ' ' '\n' | grep R= | sed 's/;*$//g' | sed 's/^R=*//g')
	GT=$(echo $results | tr ' ' '\n' | grep GT= | sed 's/;*$//g' | sed 's/^GT=*//g')
	CT=$(echo $results | tr ' ' '\n' | grep CT= | sed 's/;*$//g' | sed 's/^CT=*//g')
	CG=$(echo $results | tr ' ' '\n' | grep CG= | sed 's/;*$//g' | sed 's/^CG=*//g')
	AT=$(echo $results | tr ' ' '\n' | grep AT= | sed 's/;*$//g' | sed 's/^AT=*//g')
	AC=$(echo $results | tr ' ' '\n' | grep AC= | sed 's/;*$//g' | sed 's/^AC=*//g')
	log_likely=$(echo $results | tr ' ' '\n' | sed '5q;d' |  sed 's/;*$//g')
	
	#write to csv with clade info 
	echo "${clade},${R},${log_likely},${GT},${CT},${CG},${AT},${AC}" >> $output_file
	echo "finished $clade"
done < /global/scratch/users/chandlersutherland/e14/popgen/clades2.txt 
