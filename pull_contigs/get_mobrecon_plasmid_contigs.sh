#!/bin/bash
WORKDIR='/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads/mobrecon_run2'

for FILE in ${WORKDIR}/mobrecon_megahit_*/contig_report.txt; do
    # extract basename for each directory
    DIR=$(basename "$(dirname "$FILE")")
    # get basename num 
    N=$(echo $DIR | awk -F'_' '{print $3}')

    # output file
    OUT="${WORKDIR}/mobrecon_megahit_plasmid_contigs_${N}.txt"

    cat "$FILE" | awk '{if($2=="plasmid") print $5}' > "$OUT"
done

echo "All done!"
