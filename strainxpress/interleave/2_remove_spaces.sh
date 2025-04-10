# step 2 of preparing interleaved fastq file for strainxpress assembly

# directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/StrainXpress/wastewater_samps"

# input and output files
IN="${WORKDIR}/Site38_42423_TTRV_A_interleaved.fastq"
OUT="${WORKDIR}/tmp.fastq"

seqkit replace -p " .*" -r "" "$IN" -o "$OUT"
