# Sanaria_transposon

Publication: <br />

Bioproject PRJNA1281180 <br />
Biosample SAMN49549112<br />
SRA <br />

##Mapping DNA seq reads using BWA
```
bwa index Driver_insert.fasta
bwa index VectorBase-68_AstephensiSDA-500_Genome.fasta
```
Use (DNAseq_mapping_BWA)[] <br />
## Transposon insertion in _Anopheles stephensi_

Number of reads 
```
zgrep '@' 1_R1_001.fastq.gz | wc -l
```




