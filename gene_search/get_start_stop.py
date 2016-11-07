'''
Author:	E. Reichenberger
Date:	10.5.2016

Purpose: Get start and stop location of locus tag (from gene_ids.txt file)
'''

import sys
import os

import Bio
from Bio import GenBank
from Bio import SeqIO
from Bio import SeqFeature
from Bio.Seq import Seq


def strip_it(string_name):
	# STRIP CHARACTERS: Remove needling characters often found in lists
	string_name = str(string_name)
	stripers = ['[', ']', '\'', '"']
	for s in stripers:
		string_name = string_name.replace(s, '')
		string_name = string_name.lstrip()
	return string_name

locus_tags = {}

with open('gene_ids.txt', 'r') as input_file:
	for line in input_file.readlines():
		locus_tag = line.split('\t')[0]
		label = line.split('\t')[2]
		if locus_tag not in locus_tags:
			locus_tags[locus_tag] = label
			#locus_tags.append(locus_tag)

print(locus_tags)
		

with open('EDL933_annotation_file.txt', 'w') as output_file:
	output_file.write('\t'.join(['Start', 'Stop', 'Label']) + '\n')
	for record in SeqIO.parse('CP008957.gbk', 'genbank'):
		for feature in record.features: #Note: Need to find some methods to clean tables (e.g., Features) of rows with 'NA's only
			f_type = feature.type
			if f_type != 'source': # source information not necessary
				locus_val = strip_it(str(feature.qualifiers.get('locus_tag')))
				if locus_val in locus_tags:
					feature_position = feature.location
					feature_position = strip_it(str(feature_position))

					position = feature_position.split('(')[0]
					start_val = position.split(':')[0]
					stop_val = position.split(':')[1]

					string = '\t'.join([start_val, stop_val, locus_tags[locus_val]]) + '\n'

					print(string)
					output_file.write(string)
					#print(stop_val, start_val, locus_val)
					#print(locus_tags[locus_val], '\n')
