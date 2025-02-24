#!/bin/bash -l
#SBATCH --job-name=viralverify_CAMI_megahit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_viralverify_CAMI_megahit_%A_%a.out 

## use viralverify to identify plasmid and virus contigs from megahit assemblies
## 10 CAMI2 marine mock metagenomes

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"
PFAM_HMM="/work/NRSAAMR/Projects/plasmids/pfam/Pfam-A.hmm"
BLAST_DB="/work/NRSAAMR/Projects/plasmids/refseq/blastdb/nt"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasmids

# input files
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
ASSEMBLY="${WORKDIR}/CAMI2_${SAMPLE_ID}_megahit/final.contigs.fa"

# output files
OUT="${WORKDIR}/viralverify_megahit_${SAMPLE_ID}/"

# run viralverify
viralverify -f "$ASSEMBLY" -o "$OUT" --hmm "$PFAM_HMM" --db "$BLAST_DB" -p -t 32
