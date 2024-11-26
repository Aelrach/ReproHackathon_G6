process gene_pathway_analysis {
    publishDir "results/analysis", mode: 'copy', overwrite = true
    
    input:
    path analysis_results 

    output:
    path "gene_pathway_results.csv", emit: pathway_result
    path "*.pdf"

    script:
    """
    GenePathway.R $analysis_results gene_pathway_results.csv
    """
}
