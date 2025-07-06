#!/bin/bash -l
#SBATCH --job-name=plasX_denovo_CAMI_CE
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_plasX_denovo_CAMI_CE_%A.out

# running plasx through 200 CAMI2 CEs

# exit upon error 
set -e

# establish directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/plasmid_contig_wrangling/plasx_CEs"
CES="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/plasmid_contig_wrangling/CE_genomes/simulation_short_read/genomes"

cd "${WORKDIR}"

# activate anvio conda env
eval "$(conda shell.bash hook)"
conda activate plasx

# run plasx de novo gene family search

for CE in "${CES}"/RNODE*.fasta; do
    PREFIX=$(basename ${CE} .fasta)

    echo "Processing ${PREFIX}"

    plasx search_de_novo_families \
        -g "${PREFIX}-gene-calls.txt" \
        -o "${PREFIX}-de-novo-families.txt" \
        --threads 32 \
        --splits 32 \
        --overwrite
    echo "Completed ${PREFIX}"
done

echo "Done processing all CAMI CEs"