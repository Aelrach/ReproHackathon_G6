process trim_samples {
    publishDir "results/trimmed_files", mode: 'link', overwrite: true

    input:
    path fastq_files

    output:
    path "trimmed_*.fastq"

    script:
    """
    cutadapt -q 20 --length 25 ${fastq_files} > trimmed_${fastq_files}
    """
}

// workflow  {
//     fastq = Channel.fromPath("fastq_files/*.fastq")
//     trimmed_fastq = trim_samples(fastq)
// }