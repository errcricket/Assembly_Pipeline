#!/bin/bash

input_file=../SpecialtyGene.txt
virulence_file=virulence_genes.txt
reference_genbank_files=../reference_genbank_files/

sed 's/  \+/\t/g' $input_file > temp
sed 's/\t\t/\tNA\t/g' temp >  temp2
sed 's/\t\t/\tNA\t/g' temp2 > temp3 
sed 's/ /_/g' temp3 > temp4 

awk '{FS=OFS="\t"}{print $4, $6}' temp4 > $virulence_file

rm -rf tem*

python extract_virulence_genes_sequences.py $virulence_file $reference_genbank_files
