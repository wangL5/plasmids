#!/bin/bash -l
#SBATCH --job-name=DMC_CAMI_mpSPAdes
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_DMC_CAMI_mpSPAdes_%A_%a.out

## use DeepMicroClass (DMC) to identify plasmid contigs from mpSPAdes assemblies
## 10 CAMI2 marine mock metagenomes

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate DeepMicroClass

# input files
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
ASSEMBLY="${WORKDIR}/CAMI2_${SAMPLE_ID}_mpSPAdes/scaffolds.fasta"

# output files
OUT="${WORKDIR}/DMC_mpSPAdes_${SAMPLE_ID}"

# run DMC
DeepMicroClass predict -i "$ASSEMBLY" -o "$OUT"
