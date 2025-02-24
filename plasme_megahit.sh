#!/bin/bash -l
#SBATCH --job-name=PLASMe_CAMI_megahit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_PLASMe_CAMI_megahit_%A_%a.out

## use PLASMe to identify plasmid contigs from megahit assemblies
## 10 CAMI2 marine mock metagenomes

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"
PLASME_DIR="/work/NRSAAMR/Projects/plasmids/PLASMe"
DB="/home/lwang01/plasmids/PLASMe/DB"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasme

# input files
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
ASSEMBLY="${WORKDIR}/CAMI2_${SAMPLE_ID}_megahit/final.contigs.fa"

# output files
OUT="${WORKDIR}/plasme_megahit_${SAMPLE_ID}"

# run PLASMe
"${PLASME_DIR}/PLASMe.py" "$ASSEMBLY" "$OUT" -d "$DB"
