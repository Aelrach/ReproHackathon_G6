# ReproHackathon_G6
Repository made for the ReproHackathon course of the Master 2 AMI2B program (Computational Biology) at Paris-Saclay University. The goal is to reproduce part of the results shown in : https://doi.org/10.1038/s41467-020-15966-7

## **Usage**
Here is how you can run the pipeline. `--sra`, `--fasta_genome` and `--gff` are **mandatory arguments**.
```bash
. run.sh --sra "SRR10379721,SRR10379722" --fasta_genome "https://ftp.ensemblgenomes.ebi.ac.uk/pub/bacteria/release-60/fasta/bacteria_26_collection/staphylococcus_aureus_subsp_aureus_nctc_8325_gca_000013425/dna/Staphylococcus_aureus_subsp_aureus_nctc_8325_gca_000013425.ASM1342v1_.dna.toplevel.fa.gz" --gff "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/013/425/GCF_000013425.1_ASM1342v1/GCF_000013425.1_ASM1342v1_genomic.gff.gz"
```
