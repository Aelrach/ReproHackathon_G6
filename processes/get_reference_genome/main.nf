process get_reference_genome {
    publishDir "results/database", mode: 'move', overwrite: true

    input:
    val link_reference_genome
    val fasta_is_compressed
    
    output:
    path "ref_genome.fa", emit: reference_fasta

    script:
    if (fasta_is_compressed == 2) {
        """
        wget -q -O ref_genome.fa.zip "$link_reference_genome"
        unzip ref_genome.fa.zip 
        """
    } else if (fasta_is_compressed == 1) {
        """
        wget -q -O ref_genome.fa.gz "$link_reference_genome"
        gunzip ref_genome.fa.gz
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