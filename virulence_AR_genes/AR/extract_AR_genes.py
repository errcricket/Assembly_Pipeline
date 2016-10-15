'''
Author:	E. Reichenberger
Date:	10.13.2016

Purpse:	Using import gene file, get name of strain and locus_tag. Using the strain name and locus_tag, extract the nucleotide sequence from the strain's genbank file and place into fasta file that will be used with LS-BSR.
'''

import sys
import os
import Bio
from Bio import GenBank
from Bio import SeqIO
from Bio import SeqFeature
from Bio.Seq import Seq

#------------------DEFINITIONS
def get_genes(in_file, dic):
	with open(in_file, 'r') as input_file:
		input_file.readline()
		for line in input_file.readlines():
			sLine = line.split('\t')
			organism = sLine[0].replace('_', ' ')
			locus_tag = sLine[1].replace('\n', '')
			
			if organism not in dic:
				dic[organism] = [] 
			if locus_tag not in dic[organism]:
				dic[organism].append(locus_tag)

def strip_it(string_name):
	# STRIP CHARACTERS: Remove needling characters often found in lists
	string_name = str(string_name)
	stripers = ['[', ']', '\'', '"']
	for s in stripers:
		string_name = string_name.replace(s, '')
		string_name = string_name.lstrip()
	return string_name

def find_locus_tags(file_name, gene_list, fasta_output_file, synonym_list):
	for record in SeqIO.parse(file_name, 'genbank'):
		seq = str(record.seq)

		for feature in record.features: 
			f_type = feature.type
			string = ''
			sym_string = ''
			accession_num = record.annotations['accessions'][0]

			if f_type == 'CDS': # source information not necessary
				gene = ''
				locus_val = feature.qualifiers.get('locus_tag')
				product = feature.qualifiers.get('product') #this may be a list
				note = feature.qualifiers.get('note') #this may be a list
				nucleotide_sequence_val = ''

				if feature.qualifiers.get('gene') is not None:
					gene = feature.qualifiers.get('gene')[0].lower() #this may be a list
					if gene in gene_list: 
						string = gene + ':'

				if feature.qualifiers.get('product') is not None:
					product = feature.qualifiers.get('product')[0] #this may be a list
					for p in product.split(' '):
						if p.lower() in gene_list:
							string = string + product
							print(file_name.split('/')[-1], p)

				if feature.qualifiers.get('gene_synonym') is not None and feature.qualifiers.get('gene') is not None:
					gene_synonym = feature.qualifiers.get('gene_synonym') #this may be a list
					if gene in gene_list:
						sym_string = gene_synonym 
						#synonym_list.append(file_name.split('/')[-1], gene, gene_synonym)
						#print(file_name.split('/')[-1], gene, gene_synonym)
						#print(product)	


				if string != '':
					feature_position = strip_it(str(feature.location))

					position = feature_position.split('(')[0]
					start = int(position.split(':')[0])
					stop = int(position.split(':')[1])
				
					orientation = feature_position.split('(')[1].replace(')', '')
					orientation = orientation.replace('+', 'forward')
					orientation = orientation.replace('-', 'complement')

					nucleotide_sequence = seq[start:stop]
				
					#print(locus_val[0], product[0], nucleotide_sequence)
					fasta_output_file.write('>' + locus_val[0] + ':' + accession_num + ':' + string.replace(' ', '_') + '\n' + nucleotide_sequence + '\n')
#-------------------------------------------------------------------

#------------------------------VARIABLE ASSIGNMENT
arguments = sys.argv
gene_input_file = arguments[1]
reference_file_locations = arguments[2]
AR_genes_file = arguments[3]
#gene_input_file = 'gene_list.txt'
genes = []
#reference_file_locations = '../reference_genbank_files/'
reference_list = ['CP008957.gbk', 'NC_002695.gbk', 'U00096.gbk']
gene_dic = {}
found_genes = []
synonyms = []

with open(gene_input_file, 'r') as input_file:
	for line in input_file.readlines():
		genes.append(line.replace('\n', '').lower())

print(genes)

with open(AR_genes_file, 'w') as output_file:
#with open('AR_genes.fasta', 'w') as output_file:
	for ref in reference_list:
		file_name = reference_file_locations + ref
		find_locus_tags(file_name, genes, output_file, synonyms)
			

	

'''
get_genes(gene_input_file, gene_dic)

mapping_dictionary = {'Escherichia coli O157:H7 str. EDL933':'CP008957.gbk', 'Escherichia coli O157:H7 str. Sakai':'NC_002695.gbk', 'Escherichia coli str. K-12 substr. MG1655':'U00096.gbk'}

with open('AR_genes.fasta', 'w') as output_file:
	for g in gene_dic:
		f_name = mapping_dictionary[g]
		f_name = reference_file_locations + f_name
		l_tag = gene_dic[g]
		find_locus_tags(f_name, l_tag, output_file)
'''
