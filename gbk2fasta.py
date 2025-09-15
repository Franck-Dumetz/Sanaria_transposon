from Bio import SeqIO

# Input GenBank file
input_file = "PATH/Sanaria/Driver_insert.gbk"
output_file = "PATH/Sanaria/Driver_insert.fasta"

# Convert GenBank to FASTA
count = SeqIO.convert(input_file, "genbank", output_file, "fasta")

print(f"Converted {count} record(s) to FASTA.")
