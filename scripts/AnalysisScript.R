# Load required libraries
.libPaths("/mnt/c/Program Files/R/R-3.4.1/library")
library(DESeq2)
library(stringi)
library(stringr)
library(dplyr)
library(glue)
library(tibble)
library(data.table)
library(readxl)
library(ggplot2)

# Define functions
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
raw_count_table <- read.table("./counting/countdata.txt", sep=" ", header=TRUE)

# Load coldata
coldata <- read.table("coldata.txt", sep=" ", header=TRUE)
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

final_count_table <- merged[, !colnames(merged) %in% c("Geneid")]

# Filter out genes which are not expressed 
final_count_table <- final_count_table[rowSums(final_count_table[, !colnames(final_count_table) %in% c("Name")]) > 0,]

# Prepare DESeq dataset
ROWNAMES <- final_count_table$Name
final_count_table <- final_count_table[, !names(final_count_table) %in% c("Name")]
rownames(final_count_table) <- ROWNAMES

dds <- DESeqDataSetFromMatrix(countData = final_count_table,
                              colData = coldata,
                              design = ~ condition)

# Ensure correct reference definition
dds$condition <- relevel(dds$condition, ref = "control")

# Perform normalization and estimate dispersions
dds <- DESeq(dds)
resultsNames(dds)

# Run differential expression analysis
res <- results(dds, alpha = 0.05)

# Filter results for significant genes
sig_genes <- subset(res, padj < 0.05)
head(sig_genes)

# Plot MA plot
plotMA(res)

# Plot using ggplot
res$color <- ifelse(
  res$padj < 0.05 & res$log2FoldChange > 0, "red",
  ifelse(res$padj < 0.05 & res$log2FoldChange < 0, "blue", "black")
)

ggplot(as.data.frame(res), aes(y = log2FoldChange, x = log2(baseMean))) +
  geom_point(aes(color = color), alpha = 0.5) +
  scale_color_manual(values = c("red" = "red", "blue" = "blue", "black" = "black")) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "darkgrey", color = NA),
    plot.background = element_rect(fill = "darkgrey", color = NA),
    panel.grid = element_line(color = "lightgrey")
  ) +
  labs(
    title = "MA Plot of Differentially Expressed Genes",
    y = "Log2 Fold Change",
    x = "Log2 baseMean"
  )
