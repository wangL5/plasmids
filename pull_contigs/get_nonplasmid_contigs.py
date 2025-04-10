import pandas as pd
import glob
import os

# this script uses merge from pandas to combine link anonymous contig ids with genome_ids, which are associated with plasmid/non-plasmid status

work_dir = '/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/plasmid_contig_wrangling'

# get all gsa_mapping files and sort so enumerated n's match these file numbers
gsa_mapping_files = sorted(glob.glob(os.path.join(work_dir, "gsa_mapping_*.tsv")))

# assign df1 as all nonplasmid contigs from metadata. This stays put and is not part of the for loop.
df1_path = os.path.join(work_dir, "CAMI2_nonplasmid_contigs")
df1 = pd.read_csv(df1_path, delim_whitespace=True)

# initialize dictionaries
df2_dict = {}
merged_dict = {}
merged_contig_ids_dict = {}

# go through the gsa mapping files 

for n, file in enumerate(gsa_mapping_files):
    df2_dict[n] = pd.read_csv(file, delim_whitespace=True)

    # strip the # from the column headers in df2
    df2_dict[n].columns = [col.lstrip('#') for col in df2_dict[n].columns]

    # merge the two dataframes
    # specifies columns in df1 and df2 that will be used for merge
    merged_dict[n] = pd.merge(df1, df2_dict[n], left_on='genome_ID', right_on='genome_id')

    # get contig IDs
    merged_contig_ids_dict[n] = merged_dict[n]['anonymous_contig_id']

# write out the contig lists
for n, contig_ids in merged_contig_ids_dict.items():
    with open(f"nonplasmid_contig_ids_{n}.txt", "w") as f:
        f.write("\n".join(contig_ids))

