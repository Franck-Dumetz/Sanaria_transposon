#!/bin/bash

# === Input files ===
INSERTIONS="PATH/output_te_insertions/Astephensi_transposon.nonref.bed"
ANNOTATION="PATH/output_te_insertions/VectorBase-68_AstephensiSDA-500.gff"

# === Temporary filtered GFF files ===
CDS="cds.gff"
EXONS="exons.gff"
GENES="genes.gff"

# === Output files ===
CDS_OUT="insertions_in_CDS.tmp"
EXON_OUT="insertions_in_exons.tmp"
GENE_OUT="insertions_in_genes.tmp"
INTERGENIC_OUT="insertions_intergenic.tmp"

FINAL_OUT="PATH/output_te_insertions/insertions_annotated.tsv"

# === Step 1: Extract feature types ===
awk '$3 == "CDS"' "$ANNOTATION" > "$CDS"
awk '$3 == "exon"' "$ANNOTATION" > "$EXONS"
awk '$3 == "gene"' "$ANNOTATION" > "$GENES"

# === Step 2: Find insertions in CDS ===
bedtools intersect -a "$INSERTIONS" -b "$CDS" -wa -wb | awk '{print $0"\tCDS"}' > "$CDS_OUT"

# === Step 3: Find insertions in exons NOT already in CDS ===
bedtools intersect -a "$INSERTIONS" -b "$EXONS" -wa -wb | grep -vFf <(cut -f1-3 "$CDS_OUT") | awk '{print $0"\tExon"}' > "$EXON_OUT"

# === Step 4: Find insertions in genes NOT already in CDS or exons ===
bedtools intersect -a "$INSERTIONS" -b "$GENES" -wa -wb | grep -vFf <(cut -f1-3 "$CDS_OUT"; cut -f1-3 "$EXON_OUT") | awk '{print $0"\tGene"}' > "$GENE_OUT"

# === Step 5: Find intergenic insertions ===
bedtools intersect -a "$INSERTIONS" -b "$GENES" -v | awk '{print $0"\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\tIntergenic"}' > "$INTERGENIC_OUT"

# === Step 6: Combine all into final output ===
cat "$CDS_OUT" "$EXON_OUT" "$GENE_OUT" "$INTERGENIC_OUT" > "$FINAL_OUT"

# === Step 7: Clean up ===
rm "$CDS" "$EXONS" "$GENES" "$CDS_OUT" "$EXON_OUT" "$GENE_OUT" "$INTERGENIC_OUT"

echo "Done. Annotated insertions written to $FINAL_OUT"
