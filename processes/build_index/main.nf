process build_index {
    publishDir "results/bowtie_index", mode: 'link', overwrite: true

    input:
    path reference_fasta

    output:
    path "genome_index.*.ebwt"

    script:
    """
    bowtie-build $reference_fasta genome_index
    """
    // This should write bowtie index files as "genome_index.1.ebwt", "genome_index.2.ebwt" etc..
}

