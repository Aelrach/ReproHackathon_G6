library(EnrichmentBrowser)

list_kegg <- list("sao03010","sao00970")
all_gene <-  list("ID" = list(), "NAME" = list())

for (KEgg in list_kegg) {
  gene_keg <- KEGGREST::keggGet(KEgg)[[1]]
  print(KEgg)
  
  for (i in seq(1,length((gene_keg$GENE)), 2)) {
    
    all_gene$ID = append(all_gene$ID, gene_keg$GENE[i])
    all_gene$NAME = append(all_gene$NAME, gene_keg$GENE[i+1])
    
  }
  
}

# Missing gene

all_gene$ID = append(all_gene$ID, "SAOUHSC_01203")
all_gene$NAME = append(all_gene$NAME, "rnc; ribonuclease III [KO:K03685] [EC:3.1.26.3]")
