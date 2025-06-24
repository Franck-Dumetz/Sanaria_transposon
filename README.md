# Sanaria_transposon

Publication: <br />

Bioproject PRJNA1281180 <br />
Biosample SAMN49549112<br />
SRA <br />

Programs: <br />
* BWA v0.7.17 <br />
* RelocaTE2 <br />
* Samtools v1.11 <br />

## Mapping DNA seq reads using BWA
```
bwa index Driver_insert.fasta
bwa index VectorBase-68_AstephensiSDA-500_Genome.fasta
```
Use [DNAseq_mapping_BWA](https://github.com/Franck-Dumetz/Sanaria_transposon/blob/main/DNAseq_mapping_BWA) to align the sequencing reads to the reference genome<br />
## Transposon insertion in _Anopheles stephensi_

Number of reads 
```
zgrep '@' 1_R1_001.fastq.gz | wc -l
```
Number of mapping reads (Primary alignments and Supplementary alignments) <br />
to the transposon
```
samtools view -c -F 4 Transposon_sorted.bam
```
to the genome of _A. stephensi_ <br />
```
samtools view -c -F 4 Astephensi_sorted.bam
```
Use [Hydrid_reads_finding.sh](https://github.com/Franck-Dumetz/Sanaria_transposon/blob/main/Hydrid_reads_finding.sh) to identify the hybrid reads <br />
Use 
ngs_te_mapper2 -f /local/projects-t3/S
erreDLab-3/fdumetz/Sanaria/30-1179934119/Astephensi/1_R1_001.fastq.gz,/local/proje
cts-t3/SerreDLab-3/fdumetz/Sanaria/30-1179934119/Astephensi/1_R2_001.fastq.gz  -l 
/local/projects-t3/SerreDLab-3/fdumetz/Sanaria/Driver_insert.fasta  -r /local/proj
ects-t3/SerreDLab-3/fdumetz/Sanaria/VectorBase-68_AstephensiSDA-500_Genome.fasta  
-o /local/projects-t3/SerreDLab-3/fdumetz/Sanaria/output_te_insertions  -p Astephe
nsi_transposon  -t 12
