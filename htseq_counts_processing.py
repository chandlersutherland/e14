import os
import pandas as pd
import glob

positions=pd.read_csv('/global/home/users/chandlersutherland/e14/data/all_NLR.bed', sep='\t', header=0, names=['Chromosome', 'start', 'end', 'gene', 'strand'], index_col=False)
positions

hv_status = pd.DataFrame(columns=['Gene', 'HV'])
hv_status[['Gene', 'HV']] = positions.gene.str.split('_', expand = True)


input_path='/global/scratch/users/chandlersutherland/e14/STAR_output/htseq_count'
output_path='/global/scratch/users/chandlersutherland/e14/STAR_output/htseq_count/summary_reports'
htseq_counts = glob.glob(os.path.join(input_path, "*_NLRs.tsv"))

dfs = []

#load in the seqcounts across accessions, and sort the necessary information 
for f in htseq_counts: 
    df= pd.read_csv(f, sep = '\t', names=['Gene', 'count'], index_col=False)
    print('Location:', f)
    filename=f.split('/')[-1].replace('.tsv', '')
    print('File Name:', filename)

    #pull out the stats and save in a separate list of dfs 
    stat=df.loc[df['Gene'].str.startswith('_', na=False)==True]
    stat['filename'] = filename
    stats.append(stat)
    
    #remove stats, and add the gene counts together 
    df = df[df["Gene"].str.contains("_")==False]
    df['filename'] = filename
    dfs.append(df)

#define two functions, merger2 that will group and output the mean counts by hv/nonhv status, and 
#zero_my_hero which returns the number of genes with no counts. Would be great to combine, but not today     
def merger2(depth, hv_status):
  counts = pd.merge(depth, hv_status)
  #return counts
  return counts.groupby(['filename', 'HV']).agg(
        mean_count=('count', 'mean'),
  )
  
def zero_my_hero(depth, hv_status):
    zeros = pd.merge(depth, hv_status)
  #return counts
    return zeros.groupby(['filename', 'HV']).agg(
        lambda x:x.eq(0).sum(),
  )
  
#apply functions to the list of dataframes dfs, generating raw_mean_counts and zero_counts
summary2 = [merger2(i, hv_status) for i in dfs]
raw_mean_counts = pd.concat(summary2)

zero_sum = [zero_my_hero(i, hv_status) for i in dfs]
zero_counts = pd.concat(zero_sum).sort_values(['filename', 'HV'])

#finally, combine all the htseq_counts generated stats into stat_output 
all_stats = pd.concat(stats)
all_stats['Gene'] = all_stats.Gene.str.replace('_', ' ')
stat_output = pd.pivot_table(all_stats, index='filename', columns='Gene')

#write out the dataframes to tsv files in summary_reports 
raw_mean_counts.to_csv(os.path.join(output_path, 'raw_mean_counts_NLRs.tsv'), sep="\t")
zero_counts.to_csv(os.path.join(output_path, 'zero_counts_NLRs.tsv'), sep="\t")
stat_output.to_csv(os.path.join(output_path, 'stats_NLRs.tsv'), sep="\t")