---
title: "README genevaR"
output: html_document
---

```{r, echo = FALSE}
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "README-"
)
```

### Description

Plot a gene of interest with structure elements (exons and UTRs) and optionally add the positions of variants.
\
\
A GFF data frame object (**gff_file**) is required as input containing the columns ` seqid`, `start`, `end`, `type` and `ID`. Type specifies `exon`, `three_prime_UTR` and `five_prime_UTR`.
\
To mark variants, a data frame (**vcf_file**) with the columns `POS`, `ANN....GENEID` and `ANN....EFFECT` is required. The gene IDs in `ANN....GENEID` should be similar to the ones used in the GFF file. `ANN....EFFECT` specifies the variant type. This file can be generated from a vcf file by using snpEFF to first split the vcf (vcfEffOnePerLine) and then SnpSift (extractFields) to filter for  `POS "ANN[*].GENEID" "ANN[*].EFFECT"`.
\
Optionally the column `Genotype` can be added for use with the **facets** option.
\
\
Currently, genevaR is installed with the code:
```{r, eval=F}
devtools::install_github("lbmountain/genevaR")
library(genevaR)
```
