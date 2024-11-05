process get_reference_genome {
    publishDir "results/database", mode: 'link'

    input:
    val link_reference_genome
    val fasta_is_compressed
    
    output:
    file "ref_genome.fa"

    script:
    if (fasta_is_compressed == 2) {
        """
        wget -q -O ref_genome.fa.zip "$link_reference_genome"
        unzip ref_genome.fa.zip -d ref_genome.fa
        """
    } else if (fasta_is_compressed == 1) {
        """
        wget -q -O ref_genome.fa.gz "$link_reference_genome"
        gzip -d -c ref_genome.fa.gz > ref_genome.fa
        """
    } else {
        """
        wget -q -O ref_genome.fa "$link_reference_genome"
        """
    }
    
}

// workflow {
//     link=Channel.value(link_reference_genome)
//     get_reference_genome(link)
// }