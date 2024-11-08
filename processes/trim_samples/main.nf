process trim_samples {
    publishDir "results/trimmed_files", mode: 'copy', overwrite: true

    input:
    path fastq_files

    output:
    path "trimmed_*.fastq"

    script:
    """
    cutadapt -q 20 --length 25 ${fastq_files} > trimmed_${fastq_files.baseName.replaceAll(/\.fasta$|\.fasta\.gz$|\.fasta\.zip$/, '')}
    """
}

// workflow  {
//     fastq = Channel.fromPath("fastq_files/*.fastq")
//     trimmed_fastq = trim_samples(fastq)
// }