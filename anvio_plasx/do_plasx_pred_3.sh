#!/bin/bash
#SBATCH --job-name=plasX_pred_scores_megahit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_plasX_megahit_pred_scores_%A.out

# running plasx through CAMI2 benchmaking metagenomes

# establish working directory
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"

# activate anvio conda env
eval "$(conda shell.bash hook)"
conda activate plasx

# run plasx plasmid score predic

for DIR in ${WORKDIR}/CAMI2_*_megahit; do
    ID=$(echo "$DIR" | awk -F'_' '{print $4}')
    # input files
    PREFIX="CAMI2_megahit_${ID}"

    plasx predict \
        -a ${PREFIX}-cogs-and-pfams.txt ${PREFIX}-de-novo-families.txt \
        -g ${PREFIX}-gene-calls.txt \
        -o ${PREFIX}-scores.txt \
        --overwrite
done
