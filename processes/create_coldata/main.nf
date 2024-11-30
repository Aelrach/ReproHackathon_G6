process create_coldata {
    publishDir "results/analysis/coldata", mode: 'copy', overwrite = true

    input:
    path bam_files
    val control_ids

    output:
    file 'coldata.txt'

    script:
    """
    create_coldata.R "${bam_files.join(' ')}" $control_ids
    """
}