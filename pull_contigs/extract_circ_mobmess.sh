#!/bin/bash -l

# goal is to grab the complete circular assemblies from the mobmess test fasta file
# use the metadata to grab the circular contigs 
# extract the circular contigs from the main fasta file

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasmids

WORKDIR="/home/lwang01/plasmids/MobMess/test"

# grab the contigs with test-contigs-circular.txt where second column = 1 

awk '$2 == "1" { print $1}' ${WORKDIR}/test-contigs-circular.txt > mobmess_circular_tmp.txt

# pipe into the program that extract sequences based on a list of seqs

seqtk subseq ${WORKDIR}/test-contigs.fa mobmess_circular_tmp.txt > mobmess-circular-contigs.fa

echo "done" 


