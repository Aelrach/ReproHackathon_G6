process get_annotations {
    publishDir "results/get_annotations", mode: 'copy'

    input:
    file link_annotation_genome

    output:
    file "*.txt"

    script:
    """
    wget -O reference.gff "$link_annotation_genome"
    """
}