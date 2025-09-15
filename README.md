# Sanaria_transposon

Publication: Successful insertion and expression of a tetracycline transactivator in Anopheles stephensi associated with increased egg production and decreased hatching rate <br />

Bioproject PRJNA1281180 <br />
Biosample SAMN49549112<br />
SRA SRR34189523 <br />

Programs: <br />
* BWA v0.7.17 <br />
* [ngs_te_mapper2](https://github.com/bergmanlab/ngs_te_mapper2) <br />
* Samtools v1.11 <br />
<br />
All data regarding the genome, annotation and other aspects of the genome of _A. stephensi_ were downloaded from VectorDB, version 68<br />


## Mapping DNA seq reads using BWA
```
bwa index Driver_insert.fasta
bwa index VectorBase-68_AstephensiSDA-500_Genome.fasta
```
Use [DNAseq_mapping_BWA.sh](https://github.com/Franck-Dumetz/Sanaria_transposon/blob/main/DNAseq_mapping_BWA.sh) to align the sequencing reads to the reference genome<br />
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

### Using ngs_te_mapper2 to map transposable elements: <br />
Index the reference genome
```
bwa index VectorBase-68_AstephensiSDA-500_Genome.fasta
samtools faidx VectorBase-68_AstephensiSDA-500_Genome.fasta
```
Create a local writable RepeatMasker library
```
mkdir -p ~/RepeatMasker_Lib
cp /usr/local/packages/miniconda3/envs/ngs_te_mapper2/share/RepeatMasker/Libraries/* PATH/RepeatMasker_Lib
```
```
export REPEATMASKER_LIB_DIR=PATH/RepeatMasker_Lib
```
Run ngs_te_mapper2
```
ngs_te_mapper2 -f PATH/1_R1_001.fastq.gz,PATH/1_R2_001.fastq.gz -l PATH/Driver_insert.fasta -r PATH/VectorBase-68_AstephensiSDA-500_Genome.fasta -o PATH/output_te_insertions -p Astephensi_transposon -t 12
```
Then CDS, exonic or intergenic regions were annotated using [intersection_CDS-inter-exon.sh](https://github.com/Franck-Dumetz/Sanaria_transposon/blob/main/intersection_CDS-inter-exon.sh)
