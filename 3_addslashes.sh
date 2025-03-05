# step 3 of preparing interleaved fastq file for strainxpress assembly

# directories
WORKDIR="/work/NRSAAMR/Projects/plasmids/StrainXpress/wastewater_samps"

# input and output files
IN="${WORKDIR}/tmp.fastq"
OUT="${WORKDIR}/Site38_42423_TTRV_A_interleaved.final.fastq"

reformat.sh in="$IN" out="$OUT" addslash=true interleaved=true
