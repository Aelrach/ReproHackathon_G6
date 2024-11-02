include { get_fastq } from "/processes/download_fastQ.nf"

include { trimsamples } from "/processes/trim_samples.nf"

include { get_reference_genome } from "/processes/download_get_reference_genome.nf"
include { create_index } from "/processes/build_index.nf"
include { map_to_genome } from "/processes/map_to_genome.nf"

include { get_annotations } from "/processes/download_fastQ.nf"
// include { counting } from "/processes/counting.nf"

workflow {
    fastq_files = get_fastq()
    trimmed_fastq = trim_samples(fastq_files)
    reference_fasta = get_reference_genome()
    annotation = get_annotations()
    bam_files = map_to_genome(reference_fasta, trimmed_fastq)
}
