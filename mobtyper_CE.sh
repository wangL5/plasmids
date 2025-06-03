#!/bin/bash -l
#SBATCH --job-name=mobtyper_CAMI_CEs
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_mobtyper_CAMI_CE_%A.out

## use mob-typer to classify plasmid types of CAMI2 marine CEs

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/plasmid_contig_wrangling/CE_genomes/simulation_short_read/genomes"
cd ${WORKDIR}

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate mobsuite

# initiate a counter for processing of 200 fasta files 
count=0
total=$(ls *.fasta | wc -l)

# run mob-typer on the fasta files separately 
for FILE in *.fasta; do 
    ((count++))
    echo "Processing file $count of $total: ${FILE}"
    if mob_typer --infile ${FILE} --out_file ${FILE}_mobtyper_results.txt; then
        echo "Successfully processed ${FILE}"
    else
        echo "Error processing ${FILE}" >&2
    fi
done

echo "Completed processing all files" 
