#!/bin/bash -l
#SBATCH --job-name=strainxpress_wastewater 
#SBATCH --time=168:00:00
#SBATCH --mem=1000G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32

# add strainxpress directory to path 
export PATH=/home/lwang01/plasmids/StrainXpress/scripts:$PATH
echo $PATH

# directories
STRAINXPRESS="/home/lwang01/plasmids/StrainXpress/scripts"
WORKDIR="/home/lwang01/plasmids/StrainXpress/wastewater_samps"

# input and output files
IN="${WORKDIR}/Site38_42423_BPW_A_interleaved.final2.fastq"


# run strainxpress

python "${STRAINXPRESS}/strainxpress.py" -fq "$IN"
