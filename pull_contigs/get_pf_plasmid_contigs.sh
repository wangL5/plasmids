#!/bin/bash

# get plasmidfinder plasmid contigs

WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads/plasmidfinder_run2"

for FILE in ${WORKDIR}/plasmidfinder_megahit_*/data.json; do
    # extract DIR and N
    DIR=$(basename "$(dirname "$FILE")")
    N=$(echo "$DIR" | awk -F'_' '{print $3}')
    
    # output file
    OUT="${WORKDIR}/plasmidfinder_megahit_plasmid_contigs_${N}.txt"

    # extract contig list
    jq "." "$FILE" | grep "contig_name" | cut -d ' ' -f 14 | sed 's/[",]//g' > "$OUT"
done

echo "All done!"





