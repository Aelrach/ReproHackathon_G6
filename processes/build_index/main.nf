process build_index {
    publishDir "results/bowtie_index", mode: 'copy'

    input:
    file reference_fasta

    output:
    file "genome_index.*.ebwt"

    script:
    """
    bowtie-build $reference_fasta genome_index
    """
    // This should write bowtie index files as "genome_index.1.ebwt", "genome_index.2.ebwt" etc..
}

