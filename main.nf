include { dlFastqs } from "./processes/download_fastQ/"

include { trim_samples } from "./processes/trim_samples/"

include { get_reference_genome } from "./processes/get_reference_genome/"
include { build_index } from "./processes/build_index/"
include { map_to_genome } from "./processes/map_to_genome/"

// include { get_annotations } from "/processes/download_fastQ.nf"
// include { counting } from "/processes/counting.nf"

// sraids = Channel.of("SRR10379721", "SRR10379722", "SRR10379723","SRR10379724", "SRR10379725", "SRR10379726", "SRR10379727")

workflow {
    sraids = Channel.of("SRR10379721")
    link_reference_genome="https://www.ncbi.nlm.nih.gov/nuccore/CP000253.1"

    fastq_files = dlFastqs(sraids)
    trimmed_fastq = trim_samples(fastq_files)
    reference_fasta = get_reference_genome(link_reference_genome)
    bam_files = map_to_genome(reference_fasta, trimmed_fastq)
}
