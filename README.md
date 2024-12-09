# ReproHackathon_G6
Repository made for the ReproHackathon course of the Master 2 AMI2B program (Computational Biology) at Paris-Saclay University. The goal is to reproduce part of the results shown in : https://doi.org/10.1038/s41467-020-15966-7

## Installation
1) Clone the repository
```bash
git clone https://github.com/raphaelrubrice/ReproHackathon_G6.git
```
2) Move to repository folder (optional)
```bash
cd ReproHackathon_G6
```
3) Run the pipeline (follow usage below)

PS : You can run the pipeline from anywhere on your device as long as you provide the relative path to the run.sh file.
## Requirements
Make sure to have Nextflow and Docker up and running on your device. **You must log into your docker account from the terminal before running the pipeline.**

## **Usage**
Here is how you can run the pipeline. `--sra`, `--fasta_genome` and `--gff` are **mandatory arguments**. The following command is the exact command you should run if you'd like to reproduce results from the paper cited above.
```bash
. run.sh --sra "SRR10379721,SRR10379722,SRR10379723,SRR10379724,SRR10379725,SRR10379726" --control "SRR10379724,SRR10379725,SRR10379726" --fasta_genome "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/013/425/GCF_000013425.1_ASM1342v1/GCF_000013425.1_ASM1342v1_genomic.fna.gz" --gff "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/013/425/GCF_000013425.1_ASM1342v1/GCF_000013425.1_ASM1342v1_genomic.gff.gz" -t 8
```

You can learn more about command parameters by running the command :
```bash
. run.sh -h
```
or 
```bash
. run.sh --help
```
