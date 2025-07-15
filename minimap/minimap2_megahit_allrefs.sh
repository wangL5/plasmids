#!/bin/bash -l
#SBATCH --job-name=minimap_CAMI2_all_refs_megahit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --array=1-10
#SBATCH --output=slurm_minimap_CAMI2_all_refs_megahit_%A_%a.out

# run minimap2: metaplasmidspades + megahit assemblies against all CAMI2 reference genomes

# exit on any error
set -e

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/plasmid_contig_wrangling/minimap2"
# all output files will go in WORKDIR
ASSEMBLIES="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"
# this is where all the metaplasmidspades and megahit assemblies are
REF_G="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads/simulation_short_read/genomes"
# this is where all the CAMI2 reference genomes are. They can be found via *fasta

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate minimap2

# input assembly files. There are 10 assemblies.
SAMPLE_ID=$((SLURM_ARRAY_TASK_ID - 1))
ASSEMBLY="${ASSEMBLIES}/CAMI2_${SAMPLE_ID}_megahit/final.contigs.fa"

# run minimap2
for FASTA in "${REF_G}"/*.fasta; do
    REF_NAME=$(basename "$FASTA" .fasta)
    OUTPUT="${WORKDIR}/CAMI2_CE_megahit_${SAMPLE_ID}_${REF_NAME}.paf"
    minimap2 -x asm5 -t "${SLURM_CPUS_PER_TASK}" "$FASTA" "$ASSEMBLY" > "$OUTPUT"
done

echo "All minimap2 jobs completed for megahit assemblies"