#!/bin/bash -l
#SBATCH --job-name=genomad_CAMI_mpSPAdes
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_genomad_CAMI_mpSPAdes_%A_%a.out

## use genomad to identify plasmid contigs from metaplasmidspades assemblies
## 10 CAMI2 marine mock metagenomes

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"
DB="/work/NRSAAMR/Projects/plasmids/genomad_db"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate genomad

# input files
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
ASSEMBLY="${WORKDIR}/CAMI2_${SAMPLE_ID}_mpSPAdes/scaffolds.fasta"

# output files
OUT="${WORKDIR}/genomad_mpSPAdes_${SAMPLE_ID}_calibrated"

# run genomad
genomad end-to-end --cleanup --splits 8 --enable-score-calibration "$ASSEMBLY" "$OUT" "$DB"
