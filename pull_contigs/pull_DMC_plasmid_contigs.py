#!/usr/bin/env python

import pandas as pd
import argparse

# establishing input and output arguments 
parser = argparse.ArgumentParser(description="Extract plasmid contigs from DeepMicroClass output")
parser.add_argument("input_file", help="Path to input file (DeepMicroClass output tsv)")
parser.add_argument("output_file", help="Path to save the output tsv file")
args = parser.parse_args()

# read input file as tab separated
df = pd.read_csv(args.input_file, sep="\t")

# strip column names of spaces and standardize case
df.columns = df.columns.str.strip().str.lower()

# all headers should be lower case now
prob_cols = ["eukaryote", "eukaryotevirus", "plasmid", "prokaryote", "prokaryotevirus"]

plasmid_highest = df[df["plasmid"] == df[prob_cols].max(axis=1)]

contig_names = plasmid_highest[["sequence name", "plasmid"]]

contig_names.to_csv(args.output_file, sep="\t", index=False)

print("done")

