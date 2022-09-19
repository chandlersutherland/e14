library(polyester)
library(Biostrings)

fold_changes=matrix(c(1), nrow=335, ncol=1)

fasta_file = '/global/scratch/users/chandlersutherland/e14/polyester/NLR_codingseq.fa'
fasta=readDNAStringSet(fasta_file)

readspertx=rount(20* width(fasta_file)/100)

simulate_experiment(fasta_file, reads_per_transcript=readspertx, 
	num_reps=c(10), fold_changes=fold_changes, 
	outdir='global/scratch/users/chandlersutherland/e14/polyester/simulated_reads_0928')