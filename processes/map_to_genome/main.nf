process map_to_genome {
    publishDir "results/mapping", mode: 'copy', overwrite: true

    input:
    path fastq_files
    path index_prefix
    path index_files

    output:
    path "*.bam", emit: bam_files
    path "*.bai", emit: bam_indices

    // 1) Maps reads to the reference genome (-t to see how much time has gone by)
    // 2) Converts sam files into bam files and then sorts bam files
    // 3) Indexes bam files
    // 4) Removes sam files
    script:
    """
    bowtie -p $task.cpus -t -S ${index_prefix.baseName} $fastq_files ${fastq_files.baseName}.sam 
    samtools view -@ $task.cpus -b -o ${fastq_files.baseName}.bam ${fastq_files.baseName}.sam 
    samtools sort -@ $task.cpus -o ${fastq_files.baseName}.bam ${fastq_files.baseName}.bam
    samtools index -@ $task.cpus ${fastq_files.baseName}.bam
    rm ${fastq_files.baseName}.sam
    """
}

// workflow {
//     index = // output of get_reference_genome process (file)
//     fastq_files = // output of trim_samples (file)
//     map_to_genome(index, fastq_files)
// }