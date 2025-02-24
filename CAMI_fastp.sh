#!/bin/bash -l
#SBATCH --job-name=CAMI_fastp
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_CAMI_fastp_%A_%a.out

# set working directory
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasmids

# input files
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
READ1="${WORKDIR}/anonymous_reads_${SAMPLE_ID}_1.fq"
READ2="${WORKDIR}/anonymous_reads_${SAMPLE_ID}_2.fq"

# output files
OUT1="${WORKDIR}/anonymous_reads_${SAMPLE_ID}_1.fastp.fq"
OUT2="${WORKDIR}/anonymous_reads_${SAMPLE_ID}_2.fastp.fq"

# fastp command

fastp -i "$READ1" -I "$READ2" -o "$OUT1" -O "$OUT2" -q 20 -u 20
