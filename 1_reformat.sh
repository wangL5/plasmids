# step 1 of preparing interleaved fastq file for strainxpress assembly

# directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/StrainXpress/wastewater_samps"

# input and output files
READ1="${WORKDIR}/Site38_42423_TTRV_A_R1.fastq"
READ2="${WORKDIR}/Site38_42423_TTRV_A_R2.fastq"
OUT="${WORKDIR}/Site38_42423_TTRV_A_interleaved.fastq"

reformat.sh in1="$READ1" in2="$READ2" out="$OUT"
