process gene_pathway_analysis {
    publishDir "results/analysis/translation_genes", mode: 'copy', overwrite = true
    
    input:
    path analysis_results 

    output:
    path "*.pdf"

    script:
    """
    -l -c GenePathway.R "$analysis_results"
    """
}
