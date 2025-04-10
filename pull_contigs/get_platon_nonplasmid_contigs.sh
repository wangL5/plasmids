#!/bin/bash

# get plasmid and nonplasmid contigs from platon output

# establish working directory path 
WORKDIR="/home/lwang01/plasmids/CAMI2_Marine/CAMI2_reads/platon_run2"

for FILE in ${WORKDIR}/platon_mpSPAdes_*/scaffolds.chromosome.fasta; do
    DIR=$(basename "$(dirname "$FILE")")
    # extract N
    N=$(echo "$DIR" | awk -F'_' '{print $3}')
    
    # output file
    OUT="${WORKDIR}/platon_mpSPAdes_nonplasmid_contigs_${N}.txt"

    # extract contig list
    grep ">" "$FILE" | sed 's/ .*//' | sed 's/>//g' > "$OUT"
done

echo "All done!"
