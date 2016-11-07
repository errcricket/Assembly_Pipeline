'''
Author:	E. Reichenberger
Date:	10.5.2016

Purpose: Get start and stop location of locus tag (from gene_ids.txt file)
python extract_phage_regions.py in_file reference_file]
'''

import sys
import os

import Bio
from Bio import GenBank
from Bio import SeqIO
from Bio import SeqFeature
from Bio.Seq import Seq

arguments = sys.argv
in_file = arguments[1]
out_file = in_file.replace('.txt', '.fasta')
genbank_reference_file = arguments[2]

def strip_it(string_name):
	string_name = str(string_name)
	stripers = ['[', ']', '\'', '"', 'complement(', ')']
	for s in stripers:
		string_name = string_name.replace(s, '')
		string_name = string_name.lstrip()
	return string_name

locus_tags = {} 

#--Get locus tags
with open(in_file, 'r') as input_file:
#with open('modified_phage_regions_EDL933.txt', 'r') as input_file:
	for line in input_file.readlines():
		if line.startswith('complement') or line[0].isdigit() and 'N/A' not in line:
				sLine = line.split('\t')
				location = sLine[0]

				start = int(strip_it(location.split('.')[0]))
				stop = int(strip_it(location.split('.')[-1]))
				description = sLine[1].split('; ')

				for d in description:
					if d.startswith('EDL933_'):
						if d not in locus_tags:
							locus_tags[d] = {}
						sequence_header = '>' + d + ':' + description[0].replace(' ', '_')
						locus_tags[d] = {'Start':start, 'Stop':stop, 'Header':sequence_header}
			
sequence = ''

#with open('EDL933_phage_multisequence.fasta', 'w') as output_file:
with open(out_file, 'w') as output_file:
	#with open('/home/cricket/Projects/Assembly_Pipeline/reference_files/CP008957.gbk', 'r') as input_file:
	with open(genbank_reference_file, 'r') as input_file:
		output_file.write('\t'.join(['Start', 'Stop', 'Label']) + '\n')
		for record in SeqIO.parse(input_file, 'genbank'):
			sequence = str(record.seq)

		for l in locus_tags:
			n_sequence = sequence[locus_tags[l]['Start']-1:locus_tags[l]['Stop']-1]

			header = locus_tags[l]['Header'].replace('_', ' ') + '\n'
			output_file.write(header + n_sequence + '\n')
