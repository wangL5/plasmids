#!/bin/bash -l
#SBATCH --job-name=Platon_CAMI_megahit_samples_for_loop
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_platon_CAMI_megahit_forloop_%A.out

## use platon to id plasmid contigs from megahit assembly
## running jobs in for loop

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"
DB="/work/NRSAAMR/Projects/plasmids/LAKE/platon/db"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasmids

for ASSEMBLY in "${WORKDIR}/CAMI2"_*_megahit/final.contigs.fa; do
    # get directory name for each assembly
    DIR_NAME=$(basename "$(dirname "$ASSEMBLY")")
    # get the number from each directory name
    N=$(echo "$DIR_NAME" | awk -F'_' '{print $2}')

    # skip CAMI2_0_megahit assembly - already did this one
    if [ "$N" -eq 0 ]; then
        echo "Skipping $ASSEMBLY - already processed"
        continue
    fi

    # output name
    OUT="${WORKDIR}/platon_megahit_${N}"

    # run platon

    platon --db "$DB" --output "$OUT" --meta --verbose "$ASSEMBLY"

    echo "Successfully processed $ASSEMBLY to $OUT"
done
