'''
Author:	E. Reichenberger
Date:	9.20.2016

Purpose: Given a file with the start of the plasmid contigs and a fasta file (plasmid contigs are at the end after alignment to reference), create a chromosome file and a plasmid file (in the prokka directory).

python separate_plasmids_chromosomes.py $final_assembly $contig_file $chromosome_directory $plasmid_directory
'''

import sys

arguments = sys.argv
base = arguments[1]
fasta_file = arguments[2]
contig_file = arguments[3]
chromosome_directory = arguments[4]
plasmid_directory = arguments[5]

plasmid_file = plasmid_directory + base + '_P.fa'
chromosome_file = chromosome_directory + base + '_C.fa'

dic = {}

with open(contig_file, 'r') as input_file:
	for line in input_file.readlines():
		base_name = line.split(': ')[0].replace('\n', '')
		node_name = line.split(': ')[1].replace('\n', '')

		if base_name not in dic:
			dic[base_name] = ''
		dic[base_name] = node_name

string = dic[base]
print(base, string)

with open(fasta_file, 'r') as input_file, open(chromosome_file, 'w') as CF, open(plasmid_file, 'w') as PF:
	chromosome, plasmid = input_file.read().split(dic[base])
	CF.write(chromosome)
	PF.write(string + plasmid)
	PF.write(plasmid)
