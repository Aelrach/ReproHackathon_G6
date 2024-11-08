process get_annotations {
    publishDir "results/get_annotations", mode: 'copy', overwrite: true

    input:
    val link_annotation_genome
    val gff_is_compressed
    
    output:
    path "reference.gff", emit: annotation_file

    script:
    if (gff_is_compressed == 2) { // ends in .zip
        """
        wget -O reference.gff.zip "$link_annotation_genome"
        unzip reference.gff.zip
        """
    } else if (gff_is_compressed == 1) { // ends in .gz
        """
        wget -O reference.gff.gz "$link_annotation_genome"
        gunzip reference.gff.gz
        """
    } else {
         """
        wget -O reference.gff "$link_annotation_genome"
        """
    }
    
}