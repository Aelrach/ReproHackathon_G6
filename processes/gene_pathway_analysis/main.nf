process gene_pathway_analysis {
    publishDir "results/translation_genes", mode: 'copy', overwrite: true
    
    input:
    path analysis_results 

    output:
    path "*.pdf"

    script:
    """
    GenePathway.R "$analysis_results" \$PWD
    """
}
// GenePathway.R "$analysis_results"