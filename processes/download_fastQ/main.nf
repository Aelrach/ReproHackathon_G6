// nextflow.enable.dsl = 2

// params.cpus = 4  // Default number of CPUs (can be modified by the user)
// params.memory = '2G'  // Default memory allocation (can be modified by the user)

// workflow {
//     sraids = Channel.of("SRR10379721", "SRR10379722", "SRR10379723","SRR10379724", "SRR10379725", "SRR10379726", "SRR10379727")
//     fastqs = dlFastqs(sraids)
// }

process dlFastqs {
    tag "$sra_id"  // Tag the process with the SRA ID for easier tracking

    publishDir "results/fastq_files", mode: 'move', overwrite: true
    input:
    val sra_id 

    output:
    path "${sra_id}.fastq.gz", emit: fastqs 

    script:
    """
    fasterq-dump --threads ${task.cpus} --progress ${sra_id} 
    gzip ${sra_id}.fastq 
    """
}
