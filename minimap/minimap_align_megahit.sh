#!/bin/bash -l
#SBATCH --job-name=minimap_align_CAMI_2_megahit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_minimapalign_CAMI_2_megahit_%A_%a.out

# use minimap2 to align CAMI2 contigs to CAMI2 megahit minimap2 index

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads/minimap2"
CONTIGSDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/frl.publisso.de/data/frl:6425521/marine/short_read/simulation_short_read"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate minimap2

# input files
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
INDEX="${WORKDIR}/megahit_${SAMPLE_ID}_index"
CONTIGS="${CONTIGSDIR}/2018.08.15_09.49.32_sample_${SAMPLE_ID}/contigs/anonymous_gsa.fasta"

# output files 
OUTPUT="${WORKDIR}/CAMI_2_megahit_alignment_${SAMPLE_ID}"

# run minimap2
minimap2 -ax asm5 "$INDEX" "$CONTIGS" > "$OUTPUT"
