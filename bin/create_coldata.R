#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
trimmed_files_path <- args[1]
control_ids <- args[2]

# Read the list of control IDs
control_ids <- unlist(strsplit(control_ids, ","))

# Extract SRA IDs from BAM file names
extract_sra_id <- function(file_name) {
  match <- regmatches(file_name, gregexpr("SRR[0-9]+", file_name))
  if (length(match[[1]]) > 0) {
    return(match[[1]][1])
  } else {
    return(NA)
  }
}

sample_ids <- sapply(trimmed_files_path, extract_sra_id)

# Create a data frame for coldata
coldata <- data.frame(
  samples = sample_ids,
  condition = ifelse(sample_ids %in% control_ids, "control", "treatment"),
  stringsAsFactors = FALSE
)

# Write the coldata to a file
write.table(coldata, file = "coldata.txt", sep = " ", row.names = FALSE, quote = FALSE)