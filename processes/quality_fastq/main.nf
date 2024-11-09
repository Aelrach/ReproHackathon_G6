process check_quality_fastq {
    publishDir "results/FastQC_reports", mode: 'copy', overwrite: true

    input:
    path fastq_files

    output:
    path "*.html"

    script:
    """
    fastqc $fastq_files -t $task.cpus
    """
}