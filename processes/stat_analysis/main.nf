process stat_analysis {
    publishDir "results/analysis", mode: 'copy', overwrite: true
    input:
    path count_table
    path coldata_file

    output:
    path "analysis_results.txt"
    path "*.pdf"

    script:
    """
    Rscript scripts/AnalysisScript.R $count_table $coldata_file analysis_results.txt
    """
}
