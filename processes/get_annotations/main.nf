process get_annotations {
    publishDir "results/get_annotations", mode: 'link'

    input:
    file link_annotation_genome

    output:
    file "*.gff"

    script:
    """
    wget -O reference.gff "$link_annotation_genome"
    """
}