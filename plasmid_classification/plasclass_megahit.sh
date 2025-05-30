#!/bin/bash -l
#SBATCH --job-name=plasclass_CAMI_megahit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_plasclass_CAMI_megahit_%A_%a.out

## use plasclass to identify plasmid contigs from megahit assemblies
## 10 CAMI2 marine mock metagenomes

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasclass

# input files
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
ASSEMBLY="${WORKDIR}/CAMI2_${SAMPLE_ID}_megahit/final.contigs.fa"

# output files
OUT="${WORKDIR}/plasclass_megahit_${SAMPLE_ID}"

classify_fasta.py -f "$ASSEMBLY" -o "$OUT"
