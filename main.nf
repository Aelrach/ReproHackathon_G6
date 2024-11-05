include { dlFastqs } from "./processes/download_fastQ/"

include { trim_samples } from "./processes/trim_samples/"

include { get_reference_genome } from "./processes/get_reference_genome/"
include { build_index } from "./processes/build_index/"
include { map_to_genome } from "./processes/map_to_genome/"

include { get_annotations } from "./processes/get_annotations/"
include { counting } from "./processes/counting/"

// sraids = Channel.of("SRR10379721", "SRR10379722", "SRR10379723","SRR10379724", "SRR10379725", "SRR10379726", "SRR10379727")

workflow {
    sraids = Channel.of("SRR10379721")
    link_reference_genome="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP000253.1&rettype=fasta"
    link_annotation_genome="https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?db=nuccore&report=gff3&id=CP000253.1"

    fastq_files = dlFastqs(sraids)
    trimmed_fastq = trim_samples(fastq_files)
    reference_fasta = get_reference_genome(link_reference_genome)
    index = build_index(reference_fasta)
    bam_files = map_to_genome(index, trimmed_fastq)
    annot_file = get_annotations(link_annotation_genome)
    count_table = counting(annot_file, bam_files)
}
