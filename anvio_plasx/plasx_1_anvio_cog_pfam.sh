#!/bin/bash
#SBATCH --job-name=plasx_cog_pfam_CAMI_CE
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_plasX_cog_pfam_CAMI_CE_%A.out

# running plasx through 200 CAMI2 CEs
# ID genes and annotate COGs and Pfams using anvio

# exit upon error 
set -e

# establish working directory
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/plasmid_contig_wrangling/plasx_CEs"
CES="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/plasmid_contig_wrangling/CE_genomes/simulation_short_read/genomes"

# move into WD
cd "${WORKDIR}"

# activate anvio conda env
eval "$(conda shell.bash hook)"
conda activate anvio-8

# Step 1 - use anvio
# create an anvio contigs database
# T = threads

for CE in "${CES}"/RNODE*.fasta; do
    PREFIX=$(basename ${CE} .fasta)

    echo "Processing ${PREFIX}"

    # Create an anvio contigs database from the fasta file
    # - The `-L 0` parameter ensures that contigs remain intact and aren't split
    anvi-gen-contigs-database -L 0 -T 32 --project-name "$PREFIX" -f "$CE" -o "${PREFIX}.db"

    # Export gene calls (including amino acid sequences) to text file
    anvi-export-gene-calls --gene-caller prodigal -c "${PREFIX}.db" -o "${PREFIX}-gene-calls.txt"

    # Annotate COGs
    anvi-run-ncbi-cogs -T 32 --cog-version COG14 --cog-data-dir /home/lwang01/plasmids/COG_2014 -c "${PREFIX}.db"

    # Annotate Pfams
    anvi-run-pfams -T 32 --pfam-data-dir /home/lwang01/plasmids/Pfam_v32 -c "${PREFIX}.db"

    # Export functions to text file
    anvi-export-functions --annotation-sources COG14_FUNCTION,Pfam -c "${PREFIX}.db" -o "${PREFIX}-cogs-and-pfams.txt"

    echo "Completed ${PREFIX}"
done