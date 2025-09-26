#!bin/bash

# script to download refseq genomes from refseq using NCBI-CLI

# takes species_list.txt, which is a list of speceis you want to download from refseq.
# this can also be at the genus or above level 

while IFS= read -r species; do
        echo "Downloading $species"
        datasets download genome taxon "$species" --reference \
                --filename "${species// /_}.genomes.zip"
done < species_list.txt