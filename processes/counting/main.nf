process counting {
    publishDir "results/counting", mode: 'copy', overwrite: true

    input:
    path annot_file
    path bam_files

    output:
    path "*.txt"

    script:
    """
    featureCounts -t gene -g ID -F GFF -T $task.cpus -a $annot_file -o ${bam_files.baseName}_counts.txt $bam_files
    """
}