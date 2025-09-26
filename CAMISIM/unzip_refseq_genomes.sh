#!/bin/bash

# unzip refseq genome zip files 
# organize genome files into one folder

# create genome_locations table 
# genome_id "\t" path_to_genome.fasta

# plan to create meta_data with another script 
# genome_id | OTU | NCBI_ID | novelty_category

# Example zip file structure

# Archive:  Escherichia_coli.genomes.zip
#   Length      Date    Time    Name
# ---------  ---------- -----   ----
#      1593  09-24-2025 14:46   README.md
#      8773  09-24-2025 14:46   ncbi_dataset/data/assembly_data_report.jsonl
#   4699745  09-24-2025 14:46   ncbi_dataset/data/GCF_000005845.2/GCF_000005845.2_ASM584v2_genomic.fna
#   5664775  09-24-2025 14:46   ncbi_dataset/data/GCF_000008865.2/GCF_000008865.2_ASM886v2_genomic.fna
#       654  09-24-2025 14:46   ncbi_dataset/data/dataset_catalog.json


# create the directories for the unzipped data 
mkdir -p genomes
mkdir -p metadata

# make a metadata table to start 
echo -e "genome_ID\tspecies_name\tpath_to_fasta" > genomes_metadata.txt

WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMISIM/eskape_genomes"

for file in ${WORKDIR}/*.zip; do
    echo "Processing $file"

    # grab the species name 
    species_name=$(basename "$file" .genomes.zip)
    
    # make temp extraction directory 
    temp_dir="temp_${species_name}"
    mkdir -p "$temp_dir"

    # extract the zip file quietly
    unzip -q "$file" -d "$temp_dir"

    # grab all .fna files 
    find "$temp_dir" -name "*.fna" | while read fna_file; do
        # grab the GCF accession 
        gcf_id=$(basename "$fna_file" | cut -d'_' -f1-2)

        # grab the .fna basename
        fna_basename=$(basename "$fna_file" _genomic.fna)

        # rename the .fna file
        new_filename="${species_name}_${fna_basename}.fna"
        cp "$fna_file" "genomes/$new_filename"

        # grab the path
        abs_path=$(realpath "genomes/$new_filename")

        # add all this info to list 
        # genome_ID | species | path 

        printf "%s\t%s\t%s\n" "$gcf_id" "$species_name" "$abs_path" >> genomes_metadata.txt
    done

    # grab the metadata files 
    if [ -f "$temp_dir/ncbi_dataset/data/assembly_data_report.jsonl" ]; then
        cp "$temp_dir/ncbi_dataset/data/assembly_data_report.jsonl" "metadata/${species_name}_assembly_data_report.jsonl"
    fi

    if [ -f "$temp_dir/ncbi_dataset/data/dataset_catalog.json" ]; then
        cp "$temp_dir/ncbi_dataset/data/dataset_catalog.json" "metadata/${species_name}_dataset_catalog.json"
    fi

    # delete the temp directory 
    rm -rf "$temp_dir"
done
    
