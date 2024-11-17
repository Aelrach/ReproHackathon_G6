process stat_analysis {
    input:
    path count_table
    path coldata_file

    output:
    path "analysis_results.txt"

    script:
    """
    Rscript scripts/AnalysisScript.R $count_table $coldata_file analysis_results.txt
    """
}
