import os 
import pandas as pd 
from pathlib import Path 
from Bio import SeqIO


# make this into a function 
# write a main function 
# input file is input directory and output directory 
# write a --help section 
# write a progress bar 
# save metadata in output directory also as metadata.txt 

genome_dir = Path("/Users/luwang/Documents/plasmids/CAMISIM/genomes")
input_file = genome_dir.joinpath("Escherichia_coli_GCF_000008865.2_ASM886v2.fna")
output_path = Path("/Users/luwang/Documents/plasmids/CAMISIM/genomes/eskape_scaffolds").mkdir(parents=True, exist_ok=True)

metadata = []

for record in SeqIO.parse(input_file, "fasta"):
    accession = record.id
    description = record.description 
    seq_length = len(record.seq)

    # save scaffold in new file 
    filename = f'{accession}.fna'
    filepath = output_path / filename
    SeqIO.write(record, filepath, "fasta")

    # get organism and plasmid info from description 
    name = description.split(maxsplit=1)[1]
    OTU_names = name[0:2]
    OTU = "_".join(str(OTU) for OTU in OTU_names)


    if 'plasmid' in name.lower(): 
        sequence_type = 'plasmid'
    else:
        sequence_type = 'known_strain'

    # add to metadata
    metadata.append[{
        'genome_ID': accession,
        'Description': name,
        'OTU': OTU,
        'novelty_category': sequence_type,
        'Path': filepath
    }]
