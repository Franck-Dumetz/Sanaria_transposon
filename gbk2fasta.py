from Bio import SeqIO

# Input GenBank file
input_file = "/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/Driver_insert.gbk"
output_file = "/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/Driver_insert.fasta"

# Convert GenBank to FASTA
count = SeqIO.convert(input_file, "genbank", output_file, "fasta")

print(f"Converted {count} record(s) to FASTA.")
