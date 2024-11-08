process counting {
    publishDir "results/counting", mode: 'link', overwrite: true

    input:
    path annot_file
    path bam_files

    output:
    path "*.txt"

    script:
    """
    featureCounts --extraAttributes Name -t gene -g ID -F GFF -T $task.cpus -a $annot_file -o counts.txt $bam_files
    """
}