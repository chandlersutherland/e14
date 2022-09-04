import os 
import pandas as pd 

NLR_position=pd.read_csv('/global/home/users/chandlersutherland/e14/data/all_NLR.bed', sep='\t', names=['Chromosome', 'start', 'end', 'marker', 'code'], index_col=False)

for i in range(1, len(NLR_position)):
    chromosome=NLR_position.iloc[i,0]
    start=NLR_position.iloc[i,1]
    end=NLR_position.iloc[i,2]
    call=chromosome +':' + str(int(start)) + '-' + str(int(end))
    os.system('samtools coverage -r '+call+' /global/scratch/users/chandlersutherland/e14/bismark/SRR771698_bismark_bt2_sort.bam >> coverage.tsv')

