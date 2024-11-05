process map_to_genome {
    publishDir "results/mapping", mode: 'link'

    input:
    file index
    file fastq_files

    output:
    file "*.bam"

    // 1) Maps reads to the reference genome (-t to see how much time has gone by)
    // 2) Converts sam files into bam files and then sorts bam files
    // 3) Indexes bam files
    script:
    """
    bowtie -p $task.cpus -t -S ./results/bowtie_index/genome_index $fastq_files ${fastq_files.baseName}.sam 
    samtools view -b -o ${fastq_files.baseName}.bam ${fastq_files.baseName}.sam | samtools sort -@ $task.cpus > ${fastq_files.baseName}.bam
    samtools index ${fastq_files.baseName}.bam
    """
}

// workflow {
//     index = // output of get_reference_genome process (file)
//     fastq_files = // output of trim_samples (file)
//     map_to_genome(index, fastq_files)
// }