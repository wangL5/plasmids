#!/bin/bash -l
# goal is to grab the first contig from the 200 CAMI CE .fa files 

# SET WD
WORKDIR="/home/lwang01/plasmids/CAMI2_Marine/plasmid_contig_wrangling/CE_genomes/simulation_short_read/genomes"

# grab the first contig from each of the 200 CAMI2 circular elements

OUTPUT="CAMI2_200.fasta"

for FILE in *.fasta; do
    awk '/^>/{if(NR==1) {print $0} else exit; next} 
        {print $0}' "$FILE" >> "$OUTPUT"
done

echo "done" 