#!/bin/bash
#SBATCH --job-name=paml
#SBATCH --partition=savio4_htc
#SBATCH --qos=minium_htc4_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=12:00:00
#SBATCH --mail-user=chandlersutherland@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/global/home/users/chandlersutherland/slurm_stderr/slurm-%j.out
#SBATCH --output=/global/home/users/chandlersutherland/slurm_stdout/slurm-%j.out

module load python 
module load paml
source activate e14 

base=/global/scratch/users/chandlersutherland/e14/popgen/clades
output_csv=/global/scratch/users/chandlersutherland/e14/popgen/paml.csv

echo "Clade,S,N,dS_NG,dN_NG,dS_ML,dN_ML" > $output_csv

#for each clade, identify the codon alignment file and tree, then run hyphy to calculate dn/ds
while read clade
do 
	#actually run yn00
	cd ${base}/${clade}
	codeml codeml.ctl 
	echo "finished codeml $clade"
done < /global/scratch/users/chandlersutherland/e14/popgen/clades.txt

#do separately bc there seems to be a lag 
while read clade
do
    #Get the number of synonymous and nonsynonymous sites, should be the same for both estimates
    cd ${base}/${clade}
    S=$(cat 2ML.dS | grep -Eo '[+-]?[0-9]+\.[0-9]+' | wc -l)
    N=$(cat 2ML.dN | grep -Eo '[+-]?[0-9]+\.[0-9]+' | wc -l)
    
    #get the average NG dS and dN
    dS_NG=$(cat 2NG.dS | grep -Eo '[+-]?[0-9]+\.[0-9]+' | awk '{a+=$1} END{print a/NR}')
    dN_NG=$(cat 2NG.dN | grep -Eo '[+-]?[0-9]+\.[0-9]+' | awk '{a+=$1} END{print a/NR}')

    #get the average ML dS and dN
    dS_ML=$(cat 2ML.dS | grep -Eo '[+-]?[0-9]+\.[0-9]+' | awk '{a+=$1} END{print a/NR}')
    dN_ML=$(cat 2ML.dN | grep -Eo '[+-]?[0-9]+\.[0-9]+' | awk '{a+=$1} END{print a/NR}')

    #write to csv with clade info
    echo "${clade},${S},${N},${dS_NG},${dN_NG},${dS_ML},${dN_ML}" >> $output_csv
    echo "finished $clade"
done < /global/scratch/users/chandlersutherland/e14/popgen/clades.txt 
