process get_annotations {
    publishDir "results/get_annotations", mode: 'link'

    input:
    val link_annotation_genome
    val gff_is_compressed
    output:
    file "*.gff"

    script:
    if (gff_is_compressed == 2) { // ends in .zip
        """
        wget -O reference.gff.zip "$link_annotation_genome"
        unzip reference.gff.zip -d reference.gff
        """
    } else if (gff_is_gz == 1) { // ends in .gz
        """
        wget -O reference.gff.gz "$link_annotation_genome"
        gzip -d -c reference.gff.gz > reference.gff
        """
    } else {
         """
        wget -O reference.gff "$link_annotation_genome"
        """
    }
    
}