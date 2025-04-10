# step 4 of preparing interleaved fastq file for strainxpress assembly

# directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/StrainXpress/wastewater_samps"

# input and output files
IN="${WORKDIR}/Site38_42423_TTRV_A_interleaved.final.fastq"
OUT="${WORKDIR}/Site38_42423_TTRV_A_interleaved.final2.fastq"

seqkit replace -p " " -r "" "$IN" -o "$OUT"
