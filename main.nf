include { dlFastqs } from "./processes/download_fastQ/"

include { trim_samples } from "./processes/trim_samples/"

include { get_reference_genome } from "./processes/get_reference_genome/"
include { build_index } from "./processes/build_index/"
include { map_to_genome } from "./processes/map_to_genome/"

include { get_annotations } from "./processes/get_annotations/"
include { counting } from "./processes/counting/"
include { stat_analysis } from ".processes/stat_analysis/"
include { gene_pathway_analysis } from "processes/gene_pathway_analysis/"

include { check_quality_fastq } from "./processes/quality_fastq/"

// sraids = Channel.of("SRR10379721", "SRR10379722", "SRR10379723","SRR10379724", "SRR10379725", "SRR10379726", "SRR10379727")
absolute_path = Channel.value(params.wd)
sraids = Channel.of(params.sra.split(','))

link_reference_genome = Channel.value(params.fasta_genome)
fasta_is_compressed = params.fasta_compressed

link_annotation_genome = Channel.value(params.gff)
gff_is_compressed = params.gff_compressed

workflow {
    
    fastq_files = dlFastqs(sraids).fastqs
    trimmed_fastq = trim_samples(fastq_files)

    reference_fasta = get_reference_genome(link_reference_genome, fasta_is_compressed).reference_fasta
    (index_files, index_prefix) = build_index(reference_fasta)
    (bam_files, bam_indices) = map_to_genome(trimmed_fastq, index_prefix, index_files)

    annot_file = get_annotations(link_annotation_genome, gff_is_compressed).annotation_file
    bam_files = bam_files.toList()
    count_table = counting(annot_file, bam_files)

    fastq_quality = check_quality_fastq(fastq_files)

    coldata_channel = Channel.fromPath("data/coldata.txt")
    analysis_results = stat_analysis(count_table, coldata_channel)
    pathway_results = gene_pathway_analysis(analysis_results)
}
