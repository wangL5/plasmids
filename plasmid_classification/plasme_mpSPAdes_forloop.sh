#!/bin/bash -l
#SBATCH --job-name=PLASMe_CAMI_mpSPAdes_samples_for_loop
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_PLASMe_CAMI_mpSPAdes_forloop_%A.out

## use PLASMe to identify plasmid contigs from megaplasmidSPAdes
## running in for loop to avoid race conditions 

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"
PLASME_DIR="/work/NRSAAMR/Projects/plasmids/PLASMe"
DB="/home/lwang01/plasmids/PLASMe/DB"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasme

for ASSEMBLY in "${WORKDIR}/CAMI2"_*_mpSPAdes/scaffolds.fasta; do
    # get directory name for each assembly
    DIR_NAME=$(basename "$(dirname "$ASSEMBLY")")
    # get the number from each directory name
    N=$(echo "$DIR_NAME" | awk -F'_' '{print $2}')

    # output name
    OUT="${WORKDIR}/plasme_mpSPAdes_${N}"

    # run PLASMe
    "${PLASME_DIR}/PLASMe.py" "$ASSEMBLY" "$OUT" -d "$DB"

    echo "Successfully processed $ASSEMBLY to $OUT"
done
