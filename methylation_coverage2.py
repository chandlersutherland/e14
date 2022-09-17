import os 
import sys 
import pandas as pd 
import glob 
import numpy as np 

#methylation_coverage.py v2 
#the coverage runner will input each file as an argument, so this script should be written for a single file. 
f=str(sys.argv[1])
positions=pd.read_csv('/global/home/users/chandlersutherland/e14/data/all_NLR.bed', sep='\t', header=0, names=['Chromosome', 'start', 'end', 'gene', 'strand'], index_col=False)

#read in all the files into a dataframe 
print('Location:', f)
context=f.split('/')[-1].split('_')[0]
accession=f.split('_')[2]
print('Context:', context, 'Accession:', accession)
    
df=pd.read_csv(f, skiprows=1, names=['read', 'strand', 'chrom', 'position', 'context'], sep='\t')
df['accession']=accession
df['context']=context 
df['NLR']= np.nan

#define this horrible function, that determines if the cytosine is within an NLR, and outputs just those files
def methylation_counter(extraction, positions):
    for j in range(0, len(extraction)):
        for i in range(0, len(positions)):
            if extraction.iloc[j,2] == positions.iloc[i,0]:
                if positions.iloc[i,1] <= extraction.iloc[j,3] <= positions.iloc[i,2]:
                    #print('methylation match found')
                    extraction.iloc[j,6] = positions.iloc[i,3]
    
    return extraction.dropna()
                 
#apply the function to the dfs
all = methylation_counter(df, positions)
all[['NLR', 'HV']] = all.NLR.str.split('_', expand = True)

#write to a large but hopefully not as large txt file 
concat.to_csv(os.path.join('/global/scratch/users/chandlersutherland/e14/bismark/extraction/summary_reports/', accession, '_all_NLR_cytosines.txt'), sep="\t")

#next step would be to aggregate by strand counts, but that is just going to take some playing around 
