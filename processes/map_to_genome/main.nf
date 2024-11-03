process map_to_genome {
    publishDir "results/mapping", mode: 'copy'

    input:
    file reference_fasta
    file fastq_files

    output:
    file "*.bam"

    // 1) Builds bowtie indexes for mapping
    // 2) Maps reads to the reference genome (-t to see how much time has gone by)
    // 3) Converts sam files into bam files and then sorts bam files
    // 4) Indexes bam files
    script:
    """
    bowtie-build $reference_fasta genome_index
    bowtie -p $task.cpus -t -S genome_index $fastq_files ${fastq_files.baseName}.sam 
    samtools view -b -o ${fastq_files.baseName}.bam ${fastq_files.baseName}.sam | samtools sort -@ $task.cpus > ${fastq_files.baseName}.bam
    samtools index ${fastq_files.baseName}.bam
    """
}

workflow {
    reference_fasta = // output of get_reference_genome process (file)
    fastq_files = // output of trim_samples (file)
    map_to_genome(reference_fasta, fastq_files)
}