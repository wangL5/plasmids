#!/bin/bash -l
#SBATCH --job-name=platon_CAMI_mpSPAdes
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_platon_CAMI_mpSPAdes_%A_%a.out

## use platon to identify plasmid contigs from metaplasmidspades assemblies
## 10 CAMI2 marine mock metagenomes

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"
DB="/work/NRSAAMR/Projects/plasmids/LAKE/platon/db"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasmids

# input files
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
ASSEMBLY="${WORKDIR}/CAMI2_${SAMPLE_ID}_mpSPAdes/scaffolds.fasta"

# output files
OUT="${WORKDIR}/platon_mpSPAdes_${SAMPLE_ID}/"

# run platon

platon --db "$DB" --output "$OUT" --meta --verbose "$ASSEMBLY"

## platon has a --prefix flag that allows the user to provide a prefix for output files. 
## Not using - it defaults to the input file
