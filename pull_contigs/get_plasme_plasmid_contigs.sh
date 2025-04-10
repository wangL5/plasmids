#!/bin/bash

# get PLASMe plasmid contigs

# establish working directory path 
WORKDIR="/home/lwang01/plasmids/CAMI2_Marine/CAMI2_reads/plasme_run2"

for FILE in ${WORKDIR}/plasme_megahit_*; do
    # extract N
    N=$(basename "$FILE" | awk -F'_' '{print $3}')
    
    # output file
    OUT="${WORKDIR}/plasme_megahit_plasmid_contigs_${N}.txt"

    # extract contig list
    grep ">" "$FILE" | sed 's/ .*//' | sed 's/>//g' > "$OUT"
done

echo "All done!"
