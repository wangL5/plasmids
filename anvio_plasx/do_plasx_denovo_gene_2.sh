#!/bin/bash -l
#SBATCH --job-name=plasX_denovo_pred_megahit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_plasX_megahit_denovo_pred_%A.out

# running plax through CAMI2 benchmaking metagenomes

# establish working directory
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"

# activate anvio conda env
eval "$(conda shell.bash hook)"
conda activate plasx

# run plasx de novo gene family search

for DIR in ${WORKDIR}/CAMI2_*_megahit; do
    ID=$(echo "$DIR" | awk -F'_' '{print $4}')
    # input files
    PREFIX="CAMI2_megahit_${ID}"

    plasx search_de_novo_families \
        -g "${PREFIX}-gene-calls.txt" \
        -o "${PREFIX}-de-novo-families.txt" \
        --threads 32 \
        --splits 32 \
        --overwrite
done
