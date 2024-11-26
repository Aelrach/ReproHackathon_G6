library(EnrichmentBrowser)
library(stringr)
library(ggplot2)
library(ggrepel)
library(dplyr)

# Load the gene for translation factors
download.file("https://www.genome.jp/kegg-bin/download_htext?htext=sao03012", "sao03012.keg")
sao03012 = read.csv("sao03012.keg", sep = "?")

# Extract their ID and if they are T_RNA (translation factor)

sao03012 = sao03012[str_starts(sao03012$X.D.Translation.factors.KO, "C|D" ),]
sao03012 = sao03012[str_detect(sao03012, "_" )]

sao03012_id = str_split(gsub("\\D", " ", sao03012), " ")

for (vect_numb in 1:length(sao03012_id)) {
  sao03012_id[[vect_numb]] = paste0("SAOUHSC_",sao03012_id[[vect_numb]][!sao03012_id[[vect_numb]] %in% ""][1])
}

sao03012_AA_tRNA = str_detect(sao03012, "tRNA")

# Extract their ID and if they are T_RNA (others)

list_kegg <- list("sao03010","sao00970")
all_gene <-  list("ID" = list(), NAME = list(), AA_tRNA = list())

for (KEgg in list_kegg) {
  gene_keg <- KEGGREST::keggGet(KEgg)[[1]]
  
  for (i in seq(1,length((gene_keg$GENE)), 2)) {
    
    all_gene$ID = append(all_gene$ID, gene_keg$GENE[i])
    all_gene$NAME = append(all_gene$NAME, gene_keg$GENE[i+1])
    all_gene$AA_tRNA  = append(all_gene$AA_tRNA, str_detect(gene_keg$GENE[i+1], str_c("\\b(", str_c(c("pseudogene", "tRNA-", "ribosomal", "Ribosomal"), collapse = "|"), ")\\b") , negate = T) ) 
  }
}

# Missing gene

all_gene$ID = append(all_gene$ID, "SAOUHSC_01203")
all_gene$NAME = append(all_gene$NAME, "ribonuclease III") 
all_gene$AA_tRNA = append(all_gene$AA_tRNA, F) 

# Adding translator gene in all genes

all_gene$ID = append(all_gene$ID, unlist(sao03012_id))
all_gene$AA_tRNA = append(all_gene$AA_tRNA, unlist(sao03012_AA_tRNA))
  
# Filtering the gene of translation of the analysis data

args <- commandArgs(trailingOnly = TRUE)
analysis_table_path <- args[1]
analysis_table <- read.csv(analysis_table_path, sep=',', row.names=1, header=T)

analysis_table <- analysis_table%>%
  filter(rownames(analysis_table) %in% unlist(all_gene$ID))

analysis_table$AA_tRNA <- rownames(analysis_table) %in% unlist(all_gene$ID)[unlist(all_gene$AA_tRNA)]

a <- analysis_table %>%
  mutate(Significance = ifelse(!is.na(padj) & padj <= 0.05, "Significant", "Non-Significant"),
         id=ifelse(conv_name %in% list("frr", "infA", "tsf", "infC", "infB" ,"pth"), conv_name, ""),) %>%
  ggplot() +
  geom_point(aes(x=log2(baseMean), y=log2FoldChange, fill=Significance, color = AA_tRNA), size = 2, shape = 21, stroke = 1) +
  scale_fill_manual(values = c("Significant" = "red", "Non-Significant" = "black")) +
  scale_color_manual(values = c("TRUE" = "black", "FALSE" = "white"))+
  geom_text_repel(aes(x=log2(baseMean), y=log2FoldChange, label=id), show.legend=FALSE, size=3, box.padding=4, max.overlaps=2000) +
  geom_hline(yintercept = 0, linetype="dashed") +
  scale_y_continuous(breaks = seq(-5, 5,1)) +
  scale_x_continuous(breaks = seq(0, 20,2)) +
  theme_minimal()

pdf(file = "MA_plot_translation.pdf")
print(a)
pdf.options(
  width = 8,
  height = 7,
  family = "Helvetica",
  useDingbats = FALSE)
dev.off()



