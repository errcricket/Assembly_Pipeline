#!/bin/bash

awk '{FS=OFS="\t"}{print $6, $10, $11, $12, $13}' SpecialtyGene.txt > gene_ids.txt
 
