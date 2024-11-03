process get_reference_genome {
    publishDir "results/database", mode: 'copy'

    input:
    val link_reference_genome

    output:
    file "ref_genome.fasta"

    script:
    """
    wget -q -O ref_genome.fasta "$link_reference_genome"
    """
}

workflow {
    link=Channel.value(link_reference_genome)
    get_reference_genome(link)
}