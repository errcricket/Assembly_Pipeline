#!/bin/bash

vir_bsr_matrix=VIR_bsr_matrix.txt
vir_heatmap=Virulence_heatmap.png

cd virulence/
Rscript plot_virulence_bsr.R $vir_bsr_matrix $vir_heatmap
cd -

ar_bsr_matrix=AR_bsr_matrix_short.txt
ar_heatmap=AR_heatmap.png

cd AR/
Rscript plot_AR_bsr.R $ar_bsr_matrix $ar_heatmap
cd -
