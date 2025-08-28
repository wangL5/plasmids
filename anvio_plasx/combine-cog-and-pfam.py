#!/usr/bin/env python3

# combine all cog and pfam outputs for each of the 108 CAMI plasmid reference genomes into 1 dataframe

import os
import glob
import pandas as pd 

WORKDIR = "/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/plasmid_contig_wrangling/CE_genomes/simulation_short_read/genomes/CAMI2_108.fasta.split"

pattern = os.path.join(WORKDIR, "*-cogs-and-pfams.txt")
files = glob.glob(pattern)

print(f"Found {len(files)} files")

# intialize df
combined_cogs_and_pfams = []

for file_path in files:
    basename = os.path.basename(file_path).replace("-cogs-and-pfam.txt", "")
    print(f"Processing {basename}")
    try: 
        new_df = pd.read_csv(file_path, sep = '\t', header=0)
        if not new_df.empty: # filter out empty dataframes
            new_df["Reference_Genome"] = basename
            combined_cogs_and_pfams.append(new_df)
            print(f"Successfully added {basename} to combined_cogs_and_pfams")
            print(f"This added {len(new_df)} rows to combined_cogs_and_pfams")
        else:
            print(f"Skipped {basename} df - is empty.")
    except Exception as e:
        print(f"Error reading {file_path}: {e}")

print(f"Total dfs to concatenate: {len(combined_cogs_and_pfams)}")

if combined_cogs_and_pfams:
    final_df = pd.concat(combined_cogs_and_pfams, ignore_index=True)
    print(f"Final df shape: {final_df.shape}")
else:
    print("No dfs to concatenate")


final_df.to_csv('combined-cogs-and-pfams.txt', sep="\t", header=True, index=False)