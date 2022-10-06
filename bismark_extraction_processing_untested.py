import os 
import pandas as pd 
import glob 
import numpy as np 
import sys

#hasn't been cluster tested yet 
#define the functions

#takes in a dataframe and a list of chromosomes, and returns a list of dataframes broken by chromosome.
#Run on positions to create pos 
def break_chroms(df, chroms):
  df_chroms = []
  for i in chroms: 
    chrom_met = df[df['Chrom'] == i]
    df_chroms.append(chrom_met)

  return df_chroms
  
#copied from above, but takes in positions broken by chromosome and the methylation data broken by chromosome, and returns the methylation data with the gene names
#takes in each individual chunk by chromosome 
def namer(pos, met):
  for j in range(0, len(pos)):
    start = pos.iloc[j, 1]
    end = pos.iloc[j, 2]
    gene = pos.iloc[j, 3]
    met.loc[
      (met['Pos'].between(start,end)), 'Gene'] = gene
  return met.dropna()
  
#applies namer and break chromosome, concatenates the result and returns a final dataframe with all the chroms together and with gene names 
def bring_together(pos_chroms, df):
  final = pd.concat(
    [namer(pos_chroms[i], 
           break_chroms(df, chroms)[i]) 
    for i in range(0,5)]
    )
  final[['Gene', 'HV']] = final.Gene.str.split('_', expand = True)
  return final.sort_values('Gene').reset_index()
  
#calculates the final proportion cytosine and outputs a summary df 
#input is the output of bring_together 
def prop_cyt (together):
  identical_reads = together.groupby(['Chrom', 'Pos', 'Letter', 'Gene', 'HV', 'Mark']).count().reset_index()
  identical_reads.Mark.replace(('+', '-'), (1,0), inplace=True)
  agg = identical_reads.groupby(['Gene', 'HV']).apply(
      lambda x:
      sum(x['Mark'])/len(x['Mark']),
      ).reset_index().rename(columns={0:'prop_methylated'})
  #agg = agg.groupby('HV').mean().reset_index()
  agg['Accession'] = together.loc[0,'accession']
  agg['Context'] = together.loc[0, 'context']
  return agg
  

#input: directory of files to summarize 
directory=str(sys.argv[1])
files = glob.glob(os.path.join(directory, "*.txt"))
positions=pd.read_csv('/global/home/users/chandlersutherland/e14/data/all_NLR.bed', sep='\t', header=0, names=['Chromosome', 'start', 'end', 'gene', 'strand'], index_col=False)

dfs = reading_in(files)

#some housekeeping on the positions file 
chroms=['Chr1', 'Chr2', 'Chr3', 'Chr4', 'Chr5']
pos_chroms = break_chroms(positions, chroms)

#per-gene output
extraction = [bring_together(pos_chroms, df) for df in dfs]


summary=pd.concat([prop_cyt(df) for df in extraction])
summary=summary[[''Accession', 'Context', 'HV', 'prop_methylated']]
