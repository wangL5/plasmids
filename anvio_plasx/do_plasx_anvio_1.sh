#!/bin/bash
#SBATCH --job-name=gen_anvio_contigs_db_megahit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_plasX1_megahit_%A.out

# running plax through CAMI2 benchmaking metagenomes

# PlasX steps
# 1) ID genes and annotate COGs and Pfams using anvio
# 2) Annotate de novo gene families
# 3) Use PlasX to classify contigs as plasmid or nonplasmid seqs, based on #1 and #2 annotations

# establish working directory
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"

# activate anvio conda env
eval "$(conda shell.bash hook)"
conda activate anvio-8

# Step 1 - use anvio 
# create an anvio contigs database
# T = threads

for DIR in ${WORKDIR}/CAMI2_*_megahit; do
    N=$(echo "$DIR" | awk -F'_' '{print $4}')
    # input files
    FASTA="$DIR/final.contigs.renamed.fa"
    PREFIX="CAMI2_megahit_${N}"
   
    # Create an anvio contigs database from the fasta file
    # - The `-L 0` parameter ensures that contigs remain intact and aren't split
    anvi-gen-contigs-database -L 0 -T 32 --project-name "$PREFIX" -f "$FASTA" -o "${PREFIX}.db"

    # Export gene calls (including amino acid sequences) to text file
    anvi-export-gene-calls --gene-caller prodigal -c "${PREFIX}.db" -o "${PREFIX}-gene-calls.txt"

    # Annotate COGs
    anvi-run-ncbi-cogs -T 32 --cog-version COG14 --cog-data-dir /home/lwang01/plasmids/COG_2014 -c "${PREFIX}.db"

    # Annotate Pfams
    anvi-run-pfams -T 32 --pfam-data-dir /home/lwang01/plasmids/Pfam_v32 -c "${PREFIX}.db"

    # Export functions to text file
    anvi-export-functions --annotation-sources COG14_FUNCTION,Pfam -c "${PREFIX}.db" -o "${PREFIX}-cogs-and-pfams.txt"
done
