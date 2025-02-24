#!/bin/bash -l
#SBATCH --job-name=CAMI_bbsplit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_CAMI_bbsplit_%A_%a.out

# use bbsplit on CAMI2 Marine files to filter out human genome contamination

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"
PATHTODB="/work/NRSAAMR/Projects/plasmids/LAKE/GCF_000001405.40_GRCh38.p14_genomic.fna.gz"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasmids

# input files
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
READ1="${WORKDIR}/anonymous_reads_${SAMPLE_ID}_1.fastp.fq"
READ2="${WORKDIR}/anonymous_reads_${SAMPLE_ID}_2.fastp.fq"

# output files
OUT1="${WORKDIR}/anonymous_reads_${SAMPLE_ID}_1.fastp.bbsplit.fq"
OUT2="${WORKDIR}/anonymous_reads_${SAMPLE_ID}_2.fastp.bbsplit.fq"

# bbduk command

bbsplit.sh ref="$PATHTODB" in1="$READ1" in2="$READ2" outu1="$OUT1" outu2="$OUT2"

## basename option in bbsplit captures reads that align to the reference genome. will not use for this exercise.
## outu1&2 options capture reads that do not align to the reference genome (unmapped), which is what we want in this case 
