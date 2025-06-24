#!/bin/bash

#SBATCH --job-name=bwa_transposon
#SBATCH --output=/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/transposon/transposon_bwa.out
#SBATCH --error=/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/transposon/transposon_bwa.err
#SBATCH --mail-type=BEGIN,END --mail-user=fdumetz@som.umaryland.edu
#SBATCH --cpus-per-task=12
#SBATCH --mem=80G

# ----------- USER-DEFINED VARIABLES -------------
BWA_INDEX="/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/Driver_insert.fasta"  # BWA index basename (e.g., genome.fa + genome.fa.bwt etc.)
SAMPLE_DIR="/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/30-1179934119/Astephensi"
OUTPUT_DIR="/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/transposon"
THREADS=12

# Get the input read files
READ1=$(find "$SAMPLE_DIR" -type f -name "*_R1*.fastq.gz")
READ2=$(find "$SAMPLE_DIR" -type f -name "*_R2*.fastq.gz")

# Output file naming
BASENAME=$(basename "$SAMPLE_DIR")
SAM_OUT="$OUTPUT_DIR/${BASENAME}_aligned.sam"
BAM_OUT="$OUTPUT_DIR/${BASENAME}_aligned.bam"
SORTED_BAM="$OUTPUT_DIR/${BASENAME}_sorted.bam"

mkdir -p "$OUTPUT_DIR"

# ----------- ALIGN WITH BWA-MEM -------------
echo "Aligning $READ1 and $READ2 using BWA-MEM..."

bwa mem -t "$THREADS" "$BWA_INDEX" "$READ1" "$READ2" > "$SAM_OUT"

echo "Converting and sorting SAM to BAM..."
samtools view -bS "$SAM_OUT" | samtools sort -@ "$THREADS" -o "$SORTED_BAM"

samtools index "$SORTED_BAM"

# Clean up intermediate files
rm "$SAM_OUT"

echo "Done. Final BAM: $SORTED_BAM"
