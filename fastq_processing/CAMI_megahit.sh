#!/bin/bash -l
#SBATCH --job-name=CAMI_megahit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_CAMI_megahit_%A_%a.out

## use megahit to assemble CAMI2 marine mock metagenomes after QA/QC with fastp and bbsplit

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasmids

# input files
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
READ1="${WORKDIR}/anonymous_reads_${SAMPLE_ID}_1.fastp.bbsplit.fq"
READ2="${WORKDIR}/anonymous_reads_${SAMPLE_ID}_2.fastp.bbsplit.fq"

# output files
OUT="${WORKDIR}/CAMI2_${SAMPLE_ID}_megahit"

# run megahit
megahit -1 "$READ1" -2 "$READ2" -o "$OUT"
