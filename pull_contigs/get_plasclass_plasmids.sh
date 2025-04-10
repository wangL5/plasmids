#!/bin/bash

# get plasclass plasmid and nonplasmid contigs
# high confidence plasmid contigs >= 0.9
# nonplasmid contigs < 0.9

# establish file path
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads/plasclass_run1"

for FILE in ${WORKDIR}/plasclass_megahit_*; do
    # extract file number
    N=$(basename "$FILE" | awk -F'_' '{print $3}')
    # output file
    OUT="${WORKDIR}/plasclass_megahit_plasmid_contigs_${N}.txt"

    # extract contig list
    awk -F'\t' '{if ($2 >= 0.9) print $1}' "$FILE" > "$OUT"
done

echo "All done!"
