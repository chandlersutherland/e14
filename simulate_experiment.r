library(polyester)
library(Biostrings)

#start with primary transcript 
primary_fold_changes=matrix(c(1), nrow=27654, ncol=1)
primary_fasta_file = '/global/scratch/users/chandlersutherland/Athaliana/Athaliana_447_Araport11.cds_primaryTranscriptOnly.fa'
primary_fasta=readDNAStringSet(primary_fasta_file)

primary_readspertx=1092

simulate_experiment(primary_fasta_file, reads_per_transcript=primary_readspertx, 
	num_reps=c(4), fold_changes=primary_fold_changes, 
	readlen=50, paired=FALSE, 
	outdir='/global/scratch/users/chandlersutherland/e14/polyester/primary_simulated_reads_1006')
	
#then try all transcripts
#all_fold_changes=matrix(c(1), nrow=48455, ncol=1)
#all_fasta_file = '/global/scratch/users/chandlersutherland/Athaliana/Athaliana_447_Araport11.cds.fa'
#all_fasta=readDNAStringSet(all_fasta_file)

#all_readspertx=round(20* width(all_fasta_file)/100)

#simulate_experiment(all_fasta_file, reads_per_transcript=all_readspertx, 
#	num_reps=c(4), fold_changes=all_fold_changes, 
#	readlen=50, paired=FALSE, 
#	outdir='/global/scratch/users/chandlersutherland/e14/polyester/primary_simulated_reads_1006')

