#!/bin/bash

input_file=../SpecialtyGene.txt
ar_genes_file=ar_genes.txt
gene_list_file=gene_list.txt
reference_genbank_files=../reference_genbank_files/
output_file=AR_genes.fasta

sed 's/  \+/\t/g' $input_file > temp
sed 's/\t\t/\tNA\t/g' temp >  temp2
sed 's/\t\t/\tNA\t/g' temp2 > temp3 
sed 's/ /_/g' temp3 > temp4 

awk '{FS=OFS="\t"}{print $4, $6}' temp4 > $ar_genes_file
rm -rf tem*

python extract_AR_genes.py $gene_list_file $reference_genbank_files $output_file
#replace all ^I^I with ^INA^I (vim)
