process stat_analysis {
    publishDir "results/analysis/deseq2", mode: 'copy', overwrite: true
    input:
    path count_table
    path coldata_file

    output:
    path "deseq_input_countdata.csv"
    path "vst_table.csv"
    path "deseq_results.csv"
    path "*.pdf"

    script:
    """
    ./AnalysisScript.R $count_table $coldata_file deseq_input_countdata.csv vst_table.csv deseq_results.csv
    """
}
