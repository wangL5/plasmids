#!/bin/bash

# use a genome_ID list to get NCBI_ID

genome_ID="/home/lwang01/plasmids/CAMISIM/eskape_genomes/genome_IDs.txt"
echo -e "genome_ID\tNCBI_ID" > eskape_meta_data.txt

# read all lines into an array (NCBI was being weird w/o this)
mapfile -t gcf_array < "$genome_ID"

for GCF_ID in "${gcf_array[@]}"; do
    if [[ -n "$GCF_ID" ]]; then
        echo "processing $GCF_ID"
        # grab the first NCBI ID if there are multiple
        NCBI_ID=$(esearch -db assembly -query "$GCF_ID" | elink -target taxonomy | efetch -format uid | head -n 1)
        echo -e "$GCF_ID\t$NCBI_ID" >> eskape_meta_data.txt
    fi
done