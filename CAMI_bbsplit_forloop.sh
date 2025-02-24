#!/bin/bash -l
#SBATCH --job-name=CAMI_bbsplit
#SBATCH --time=168:00:00
#SBATCH --mem=250G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_CAMI_bbsplit_%A.out

# use bbsplit on CAMI2 Marine files to filter out human genome contamination
# instead of running things in batch, running this job sequentially to avoid competition for the same reference genome

# set directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads"
PATHTODB="/work/NRSAAMR/Projects/plasmids/LAKE/GCF_000001405.40_GRCh38.p14_genomic.fna.gz"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate plasmids

# input files

for READ1 in "$WORKDIR"/*_1.fastp.fq; do
        ## establish variables for READ2 and BASENAME (will use in output)
        READ2="${READ1/_1.fastp.fq/_2.fastp.fq}"  # string substitution in this var, replaces with _2.fastp.fq
        BASENAME="$(basename "$READ1" _1.fastp.fq)"  # extracts basename from file, removes suffix
        
        # run bbsplit
        bbsplit.sh ref="$PATHTODB" \
        in1="$READ1" in2="$READ2" \
        outu1="$WORKDIR/${BASENAME}_1.fastp.bbsplit.fq" \
        outu2="$WORKDIR/${BASENAME}_2.fastp.bbsplit.fq"

done


## basename option in bbsplit captures reads that align to the reference genome. will not use for this exercise.
## outu1&2 options capture reads that do not align to the reference genome (unmapped), which is what we want in this case
