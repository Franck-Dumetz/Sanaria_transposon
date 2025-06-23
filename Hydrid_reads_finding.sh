#!/bin/bash

# --- Configuration ---
GENOME="/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/VectorBase-68_AstephensiSDA-500_Genome.fasta"
TRANSPOSON="/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/Driver_insert.fasta"
READS_R1="/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/30-1179934119/00_fastq/1_R1_001.fastq.gz"   # <- Change to your actual file
READS_R2="/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/30-1179934119/00_fastq/1_R2_001.fastq.gz"   # <- Change to your actual file
OUTDIR="/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/transposon_insertion_analysis"

mkdir -p $OUTDIR

# Step 1: Index the transposon
bwa index $TRANSPOSON

# Step 2: Align reads to the transposon
/usr/local/packages/bwa-0.7.17/bin/bwa mem $TRANSPOSON $READS_R1 $READS_R2 > $OUTDIR/reads_vs_transposon.sam

# Step 3: Convert to BAM and sort
samtools view -Sb $OUTDIR/reads_vs_transposon.sam | samtools sort -o $OUTDIR/reads_vs_transposon.bam

rm $OUTDIR/reads_vs_transposon.sam

# Step 4: Extract read pairs where at least one read is partially mapped (e.g., soft-clipped)
samtools view -h $OUTDIR/reads_vs_transposon.bam | \
  awk 'BEGIN{OFS="\t"} $1 ~ /^@/ || $6 ~ /S/ || $6 ~ /H/' | \
  samtools view -Sb - > $OUTDIR/partial_mapped.bam

# Step 5: Convert BAM back to FASTQ (paired)
samtools sort -n $OUTDIR/partial_mapped.bam -o $OUTDIR/partial_mapped_sorted.bam
samtools fastq -1 $OUTDIR/hybrid_R1.fastq -2 $OUTDIR/hybrid_R2.fastq -0 /dev/null -s /dev/null -n $OUTDIR/partial_mapped_sorted.bam

# Step 6: Index the genome
bwa index $GENOME

# Step 7: Align hybrid reads to the genome
/usr/local/packages/bwa-0.7.17/bin/bwa mem $GENOME $OUTDIR/hybrid_R1.fastq $OUTDIR/hybrid_R2.fastq > $OUTDIR/hybrids_vs_genome.sam

echo "✅ Done. Review $OUTDIR/hybrids_vs_genome.sam for insertion site analysis."
