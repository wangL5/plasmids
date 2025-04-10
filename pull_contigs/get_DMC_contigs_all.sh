#!/bin/bash -l

# script to extract plasmid and non-plasmid contigs from DeepMicroClass output
# DeepMicroClass outputs probabilities of each contig belonging in each class
# Eukaryote EukaryoteVirus  Plasmid Prokaryote  ProkaryoteVirus
# for plasmid contigs - pulling out the rows with highest plasmid probability 
# directories, column nums, and file names are hard coded in 

# establish working dir
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads/DMC_run1"

# loop over DMC megahit output files 
# get plasmid contigs 
for dir in ${WORKDIR}/DMC_megahit_*/; do
    dir=${dir%/}  # remove the / 
    # establish input and output files 
    n=${dir##*_}
    echo "$n"
    input_file="${dir}/final.contigs.fa_pred_one-hot_hybrid.tsv"
    output_file="${WORKDIR}/DMC_megahit_plasmid_${n}_rows.txt"
    contig_file="${WORKDIR}/DMC_megahit_plasmid_${n}_contigs.txt"

    # pull out plasmid rows

    awk 'NR == 1 || ($4 > $2 && $4 > $3 && $4 > $5 && $4 > $6)' "$input_file" > "$output_file"
    echo "Processed $input_file to $output_file"

    # pull out plasmid contigs in column 1, excluding the column header row

    awk '{print $1}' "$output_file" | tail -n +2 > "$contig_file"
    echo "Extracted contigs to $contig_file"
done
    
# get non-plasmid contigs from megahit assemblies
for dir in ${WORKDIR}/DMC_megahit_*/; do
    dir=${dir%/}  # remove the / 
    # establish input and output files 
    n=${dir##*_}
    echo "$n"
    input_file="${dir}/final.contigs.fa_pred_one-hot_hybrid.tsv"
    output_file="${WORKDIR}/DMC_megahit_nonplasmid_${n}_rows.txt"
    contig_file="${WORKDIR}/DMC_megahit_nonplasmid_${n}_contigs.txt"

    # pull out nonplasmid rows

    awk 'NR == 1 || !($4 > $2 && $4 > $3 && $4 > $5 && $4 > $6)' "$input_file" > "$output_file"
    echo "Processed $input_file to $output_file"

    # pull out nonplasmid contigs 

    awk '{print $1}' "$output_file" | tail -n +2 > "$contig_file"
    echo "Extracted nonplasmid contigs to $contig_file"
done

# loop over DMC metaplasmidSPAdes output files 
# get plasmid contigs 
for dir in ${WORKDIR}/DMC_mpSPAdes_*/; do
    dir=${dir%/}  # remove the / 
    # establish input and output files 
    n=${dir##*_}
    echo "$n"
    input_file="${dir}/scaffolds.fasta_pred_one-hot_hybrid.tsv"
    output_file="${WORKDIR}/DMC_mpSPAdes_plasmid_${n}_rows.txt"
    contig_file="${WORKDIR}/DMC_mpSPAdes_plasmid_${n}_contigs.txt"

    # pull out plasmid rows

    awk 'NR == 1 || ($4 > $2 && $4 > $3 && $4 > $5 && $4 > $6)' "$input_file" > "$output_file"
    echo "Processed $input_file to $output_file"

    # pull out plasmid contigs in column 1, excluding the column header row

    awk '{print $1}' "$output_file" | tail -n +2 > "$contig_file"
    echo "Extracted contigs to $contig_file"
done

# get non-plasmid contigs 
for dir in ${WORKDIR}/DMC_mpSPAdes_*/; do
    dir=${dir%/}  # remove the / 
    # establish input and output files 
    n=${dir##*_}
    echo "$n"
    input_file="${dir}/scaffolds.fasta_pred_one-hot_hybrid.tsv"
    output_file="${WORKDIR}/DMC_mpSPAdes_nonplasmid_${n}_rows.txt"
    contig_file="${WORKDIR}/DMC_mpSPAdes_nonplasmid_${n}_contigs.txt"

    # pull out nonplasmid rows

    awk 'NR == 1 || !($4 > $2 && $4 > $3 && $4 > $5 && $4 > $6)' "$input_file" > "$output_file"
    echo "Processed $input_file to $output_file"

    # pull out nonplasmid contigs 

    awk '{print $1}' "$output_file" | tail -n +2 > "$contig_file"
    echo "Extracted nonplasmid contigs to $contig_file"
done
