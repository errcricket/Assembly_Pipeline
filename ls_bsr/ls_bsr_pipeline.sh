#!/bin/bash

source activate py27
rm -rf temp*

python /usr/local/LS-BSR/ls_bsr.py -d fasta_files -p 6 -c vsearch -y temp -x VIR -g ../virulence_AR_genes/virulence/virulence_genes.fasta
python /usr/local/LS-BSR/ls_bsr.py -d fasta_files -p 6 -c vsearch -y temp1 -x AR -g ../virulence_AR_genes/AR/AR_genes.fasta
source deactivate

mv VIR* virulence/.
mv AR* AR/.
