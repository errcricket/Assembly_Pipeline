#!/bin/bash

vir_bsr_matrix=VIR_bsr_matrix_short.txt
vir_bsr_matrix_genes=VIR_bsr_matrix_short_gene_order.txt
vir_heatmap=Virulence_heatmap_genome.png
vir_heatmap_2=Virulence_heatmap_genes.png

cd virulence/
Rscript plot_virulence_bsr.R $vir_bsr_matrix $vir_heatmap $vir_bsr_matrix_genes $vir_heatmap_2
cd -

ar_bsr_matrix=AR_bsr_matrix_short.txt
ar_bsr_matrix_genes=AR_bsr_matrix_short_gene_order.txt
ar_heatmap=AR_heatmap_genome.png
ar_heatmap_2=AR_heatmap_gene.png

cd AR/
Rscript plot_AR_bsr.R $ar_bsr_matrix $ar_heatmap $ar_bsr_matrix_genes $ar_heatmap_2
cd -
