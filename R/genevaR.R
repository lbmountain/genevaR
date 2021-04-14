#' Gene and Variants Plot
#'
#' Creates a plot that visualizes the selected gene and optionally marks variant positions.
#' @param gff_file Data frame including columns "seqid", "start", "end", "type" and "ID".
#' @param gene_name ID of the gene of interest. Should be the same for the GFF and VCF input.
#' @param vcf_file Data frame including columns "POS", "ANN....GENEID", "ANN....EFFECT" and optionally "Genotype". SnpSift-filtered VCF file.
#' @param plot_title Customize plot title. Default is set to input of gene_name.
#' @param facets Split plot into facets. Set to 'variants' or 'genotype' (this requires column "Genotype").
#' @keywords gene plot variants exons gff vcf snpsift snpeff genotype
#' @export

genevaR <- function(gff_file, gene_name, vcf_file=NULL, plot_title=gene_name, facets) {
  ##load required packages
  if (!require(tidyverse)) install.packages('tidyverse')
  library(tidyverse)
  if (!require(rtracklayer)) install.packages('rtracklayer')
  library(rtracklayer)


  ##get positional data for gene structures
  genecheck <- gff_file %>% filter(ID==gene_name & type=="gene")

  genedat <- gff_file %>% filter(seqid==genecheck$seqid & start>=genecheck$start & end<=genecheck$end)

  genebackbone <- genedat %>% filter(type %in% c("gene"))
  gene3p <- genedat %>% filter(type %in% c("three_prime_UTR"))
  gene5p <- genedat %>% filter(type %in% c("five_prime_UTR"))
  exons <- genedat %>% filter(type %in% c("exon"))



  if (is_empty(vcf_file)) {
    ##plot without variants
    ggplot()+
      geom_segment(genebackbone, mapping=aes(x=start, y=0, xend=end, yend=0), size=2)+
      geom_segment(gene3p, mapping=aes(x=start, y=0, xend=end, yend=0), size=5)+
      geom_segment(gene5p, mapping=aes(x=start, y=0, xend=end, yend=0), size=5)+
      geom_text(gene5p[1,], mapping=aes(x=start, y=-0.7, label=paste("5'-UTR")))+
      geom_segment(exons, mapping=aes(x=start, y=0, xend=end, yend=0,), size=4)+
      scale_y_continuous(limits=c(-1, 1))+
      theme_classic()+
      theme(strip.background = element_rect(colour=NA,fill=NA))+
      theme(axis.text.y = element_blank())+
      theme(axis.ticks.y = element_blank())+
      labs(x="Chromosomal position", y=NULL, title=plot_title)
  }


  else {
    ##merge vcf data file with gff data file
    vcf <- vcf_file %>% rename("ANN....GENEID"="ID", "ANN....EFFECT"="Effect")

    ##filter for specific gene
    onegene <- vcf %>% filter(ID==gene_name)
    onegene$POS <- as.numeric(onegene$POS)

    ##plot
    ggplot()+
      geom_segment(genebackbone, mapping=aes(x=start, y=0, xend=end, yend=0), size=2)+
      geom_segment(gene3p, mapping=aes(x=start, y=0, xend=end, yend=0), size=5)+
      geom_segment(gene5p, mapping=aes(x=start, y=0, xend=end, yend=0), size=5)+
      geom_text(gene5p[1,], mapping=aes(x=start, y=-0.7, label=paste("5'-UTR")))+
      geom_segment(exons, mapping=aes(x=start, y=0, xend=end, yend=0,), size=4)+
      geom_segment(onegene, mapping=aes(x=POS, y=-0.5, xend=POS, yend=0.5, colour=Effect), show.legend = T)+
      {if(facets=="genotype")
        facet_wrap(~Genotype)}+
      {if(facets=="variants")
        facet_wrap(~Effect)}+
      scale_y_continuous(limits=c(-1, 1))+
      guides(colour = guide_legend(title = "Type of variant"))+
      theme_classic()+
      theme(strip.background = element_rect(colour=NA,fill=NA))+
      theme(axis.text.y = element_blank())+
      theme(axis.ticks.y = element_blank())+
      theme(legend.background = element_rect(fill=NA))+
      labs(x="Chromosomal position", y=NULL, title=plot_title)
  }
}
