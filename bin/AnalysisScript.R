#!/usr/local/bin Rscript
library(DESeq2)
library(stringi)
library(stringr)
library(dplyr)
library(glue)
library(readxl)
library(ggplot2)

# Capture command line arguments
args <- commandArgs(trailingOnly = TRUE)
count_table_path <- args[1]
coldata_file_path <- args[2]
output_finalcountdata_path <- args[3]
output_vst_path <- args[4]
output_file_path <- args[5]


# Define helper functions
format_count_data <- function(count_table, coldata) {
  columns <- colnames(count_table)
  conditions <- unique(c((coldata$condition)))
  
  samples <- rep("", length(coldata$condition))
  
  for (cond in seq(length(conditions))) {
    iter <- 1
    i <- 1
    for (i in seq(length(coldata$condition))) {
      sample_condition <- c(coldata$condition)[i]
      
      if (sample_condition == conditions[cond]) {
        samples[i] <- paste(sample_condition, glue("_{iter}"), sep="")
        iter <- iter + 1
      }
    }
  }
  
  print(samples)
  sample_columns <- columns[str_detect(columns, ".bam")]
  
  final_columns <- rep("", length(coldata$condition))
  for (j in seq(length(sample_columns))) {
    for (i in seq(length(samples))) {
      if (isTRUE(str_detect(sample_columns[j], c(coldata$samples)[i]))) {
        final_columns[j] <- samples[i]
      }
    }
  }
  table <- count_table[,c("Geneid", sample_columns)]
  names(table) <- c("Geneid", final_columns)
  table$Geneid <- str_replace(table$Geneid, "gene-", "")
  
  cols <- c("Geneid", samples)
  table <- table[, c(cols, setdiff(names(table), cols))]
  
  coldata$samples <- samples
  output <- list("countdata" = table, "coldata" = coldata)
  return(output)
}

make_names_unique <- function(data, column) {
  column <- deparse(substitute(column))
  
  data$occurrence <- ave(seq_len(nrow(data)), data[[column]], FUN = seq_along)
  
  data[[column]] <- ifelse(
    data$occurrence == 1,
    data[[column]],
    paste0(data[[column]], "_", data$occurrence - 1)
  )
  
  data$occurrence <- NULL
  
  return(data)
}

# Load count table
raw_count_table <- read.table(count_table_path, sep=" ", header=TRUE)

# Load coldata
coldata <- read.table(coldata_file_path, sep=" ", header=TRUE)
coldata$condition <- as.character(coldata$condition)
coldata$samples <- as.character(coldata$samples)

# Format Count table to better suit our needs
output <- format_count_data(raw_count_table, coldata)
format_count_table <- output$countdata
coldata <- output$coldata

# Load gene_ID to gene names table
ID_to_Names <- read_excel("GeneSpecificInformation_NCTC8325.xlsx")
gene_names <- rep("", length=length(ID_to_Names$`pan gene symbol`))
for (row in seq(length(ID_to_Names$`pan gene symbol`))) {
  if (isTRUE(ID_to_Names$`pan gene symbol`[row] == "-")) {
    gene_names[row] <- ID_to_Names$`locus tag`[row]
  } else {
    gene_names[row] <- ID_to_Names$`pan gene symbol`[row]
  }
}

ID_to_Names$Name <- gene_names
ID_to_Names <- ID_to_Names %>% select(`locus tag`, Name)
colnames(ID_to_Names) <- c("Geneid", "Name")
ID_to_Names <- make_names_unique(ID_to_Names, Name)

# Convert count table row ids to gene names
merged <- inner_join(ID_to_Names, format_count_table)

final_count_table <- merged #[, !colnames(merged) %in% c("Geneid")]

# Filter out genes which are not expressed 
final_count_table <- final_count_table[rowSums(final_count_table[, !colnames(final_count_table) %in% c("Name", "Geneid")]) > 0,]
ROWNAMES <- final_count_table$Geneid
GENENAMES <- final_count_table$Name
# Prepare DESeq dataset
final_count_table <- final_count_table[, !names(final_count_table) %in% c("Name", "Geneid")]
rownames(final_count_table) <- ROWNAMES

write.csv(final_count_table, file = output_finalcountdata_path, row.names = TRUE)
dds <- DESeqDataSetFromMatrix(countData = final_count_table,
                              colData = coldata,
                              design = ~ condition)

# Ensure correct reference definition
dds$condition <- relevel(dds$condition, ref = "control")

# Perform normalization and estimate dispersions
dds <- DESeq(dds)
resultsNames(dds)

# Run differential expression analysis
vsd <- vst(dds, blind=FALSE)
write.csv(assay(vsd), file = output_vst_path, row.names = TRUE)

#Plot PCA
pcaData <- plotPCA(vsd, intgroup=c("condition"), returnData=TRUE)
percentVar <- 100 * attr(pcaData, "percentVar")

a <- ggplot(pcaData, aes(PC1, PC2, color=condition)) +
  ggtitle(glue('PCA on Variance Stabilizing Transformed data.')) +
  geom_point(size=3) +
  #xlim(-12, 12) +
  #ylim(-10, 10) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) +
  geom_text(aes(label=name),vjust=2) + theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank(),
    panel.background = element_blank(),
    legend.position = "right",
    axis.ticks = element_line(size = 0.25),
    panel.border = element_rect(size = 0.25, fill = NA)
  )+scale_color_manual(values=c("#267105", "red"))
pdf(file = "PCA_on_vst.pdf")
print(a)
pdf.options(
  width = 8,
  height = 6,
  family = "Helvetica",
  useDingbats = FALSE
)
dev.off()

# Retrieve results
res <- results(dds, alpha = 0.05)

# Filter results for significant genes
sig_genes <- subset(res, padj < 0.05)
head(sig_genes)

# Plot using ggplot
res$color <- ifelse(res$padj < 0.05, "red", "black")

# Plot using ggplot
a <- ggplot(as.data.frame(res), aes(y = log2FoldChange, x = baseMean)) +
  geom_point(aes(color = color), alpha = 0.5) +
  scale_color_manual(values = c("red" = "red", "black" = "black")) +
  theme_grey() +
  labs(
    title = "MA Plot of Differentially Expressed Genes",
    y = "Log2 Fold Change",
    x = "Mean of normalized counts"
  ) +
  geom_hline(aes(yintercept=0), linetype=2) + 
  coord_cartesian(xlim=c(0.1,4*10**5), ylim=c(-4,4)) + 
  scale_x_log10()
pdf(file = "MA_plot_all_genes.pdf")
print(a)
pdf.options(
  width = 8,
  height = 7,
  family = "Helvetica",
  useDingbats = FALSE)
dev.off()

# Write the DESeq2 results to a CSV file
res <- as.data.frame(subset(res, select=-color))
res$conv_name <- GENENAMES
write.csv(res, file = output_file_path, row.names = TRUE)