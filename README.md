# ReproHackathon_G6
Repository made for the ReproHackathon course of the Master 2 AMI2B program (Computational Biology) at Paris-Saclay University. The goal is to reproduce part of the results shown in : https://doi.org/10.1038/s41467-020-15966-7

## **Usage**
Here is how you can run the pipeline. `--sra`, `--fasta_genome` and `--gff` are **mandatory arguments**.
```bash
. run.sh --sra "SRR10379721,SRR10379722,SRR10379723,SRR10379724,SRR10379725,SRR10379726" --control "SRR10379724,SRR10379725,SRR10379726" --fasta_genome "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/013/425/GCF_000013425.1_ASM1342v1/GCF_000013425.1_ASM1342v1_genomic.fna.gz" --gff "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/
013/425/GCF_000013425.1_ASM1342v1/GCF_000013425.1_ASM1342v1_genomic.gff.gz" -t 8
```
