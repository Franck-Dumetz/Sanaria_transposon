import pysam
import pandas as pd
from collections import defaultdict
from sklearn.cluster import DBSCAN

# --- FILE PATHS ---
bam_file = "/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/transposon_insertion_analysis/hybrids_vs_genome.sorted.bam"
gff_file = "/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/VectorBase-68_AstephensiSDA-500.gff"
output_file = "/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/insertion_sites.csv"

# --- LOAD BAM FILE ---
bam = pysam.AlignmentFile(bam_file, "rb")
positions = []

for read in bam:
    if not read.is_unmapped:
        chrom = bam.get_reference_name(read.reference_id)
        pos = read.reference_start
        positions.append((chrom, pos))

df = pd.DataFrame(positions, columns=["chrom", "position"])

# --- CLUSTERING ---
clustered = []
for chrom, group in df.groupby("chrom"):
    coords = group["position"].values.reshape(-1, 1)
    if len(coords) >= 2:
        clustering = DBSCAN(eps=1000, min_samples=2).fit(coords)
        group["cluster"] = clustering.labels_
        clustered.append(group)

all_clusters = pd.concat(clustered)
insertion_sites = (
    all_clusters[all_clusters["cluster"] != -1]
    .groupby(["chrom", "cluster"])["position"]
    .agg(["count", "min", "max"])
    .reset_index()
)

# --- LOAD GFF and KEEP IMPORTANT FEATURES ---
feature_priority = ["CDS", "five_prime_UTR", "three_prime_UTR", "exon", "mRNA", "gene"]

gff = pd.read_csv(
    gff_file,
    sep="\t",
    comment="#",
    header=None,
    names=["seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes"]
)

gff = gff[gff["type"].isin(feature_priority)]

# --- ANNOTATE INSERTION REGIONS ---
def classify_insertion(row):
    chrom = row["chrom"]
    start = row["min"]
    end = row["max"]

    overlap = gff[
        (gff["seqid"] == chrom) &
        (gff["end"] >= start) &
        (gff["start"] <= end)
    ]

    # Prioritize specific features
    for feature in feature_priority:
        if feature in overlap["type"].values:
            return feature

    return "intergenic"

insertion_sites["region_type"] = insertion_sites.apply(classify_insertion, axis=1)

# --- SAVE OUTPUT ---
insertion_sites.to_csv(output_file, index=False)
print(f"✅ Saved annotated insertion sites with region types to '{output_file}'")

# --- CLEAN UP ---
bam.close()