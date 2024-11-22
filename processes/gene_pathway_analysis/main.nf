process gene_pathway_analysis {
    publishDir "results/analysis", mode: 'copy', overwrite = true
    
    input:
    path analysis_results 

    output:
    path "gene_pathway_results.txt", emit: pathway_result

    script:
    """
    Rscript scripts/GenePathway.R $analysis_results gene_pathway_results.txt
    """
}
