function show_help {
    echo "Usage : $(basename $0) --sra <list_of_sra_IDS> --fasta_genome "link_to_download_genome_fasta" --gff "link_to_download_genome_annotations" --threads 4"
    echo
    echo "Required arguments :"
    echo "  --sra (-s)              Comma separated list of SRA IDs, USE QUOTES. e.g "SRR10379721,SRR10379722,SRR10379723""
    echo "  --fasta_genome (-fg)    Link to download the reference genome fasta file."
    echo "  --gff (-gff)            Link to download the reference genome annotation GFF3 file."
    echo "  --threads (-t)          Number of cpus to use during pipeline execution."
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in 
        -s|--sra) sra_ids="$2"; shift;;
        -fg|--fasta_genome) link_ref_genome="$2"; shift ;;
        -gff|--gff) link_annotations="$2"; shift ;;
        -t|--threads) THREADS="$2"; shift ;;
        -c|--clean) clean_cache="$2"; shift ;;
        -h|--help) show_help ;;
        *) echo "Unknown parameter passed: $1"; show_help ;;
    esac
    shift
done

clean_cache="${clean_cache:-1}"
THREADS="${THREADS:-4}"

if [[ -z "$sra_ids" ]] || [[ -z "$link_ref_genome" ]] || [[ -z "$link_annotations" ]]; then
    echo "Error, one or more required arguments not specified"
    show_help
fi

if [[ "$link_ref_genome" == *".zip" ]]; then
    fasta_compressed="2"
elif [[ "$link_ref_genome" == *".gz" ]]; then
    fasta_compressed="1"
else
    fasta_compressed="0"
fi

if [[ "$link_annotations" == *".zip" ]]; then
    gff_compressed="2"
elif [[ "$link_annotations" == *".gz" ]]; then
    gff_compressed="1"
else
    gff_compressed="0"
fi

# Clean nextflow cache by default
if [[ "$clean_cache" -eq 1 ]]; then
    nextflow clean -f
fi

nextflow run main.nf --sra "${sra_ids}" --fasta_genome "${link_ref_genome}" --gff "${link_annotations}" --fasta_compressed "${fasta_compressed}" --gff_compressed "${gff_compressed}" --threads ${THREADS}
