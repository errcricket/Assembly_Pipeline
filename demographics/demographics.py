'''
Author:	E. Reichenberger
Date:	1.23.2017

Purpose: Create tsv file with the strain name, the number of CDS features, the genome size, and the gc-content

Call: python demographics.py ../final_genbank/chromosome/ demographics.txt
'''

import sys
import os

import Bio
from Bio import GenBank
from Bio import SeqIO
from Bio import SeqFeature
#from Bio import Seq
from Bio.Seq import Seq
from Bio.SeqUtils import GC 
from Bio.SeqUtils import GC123

def strip_it(string_name):
	# STRIP CHARACTERS: Remove needling characters often found in lists
	string_name = str(string_name)
	stripers = ['[', ']', '\'', '"']
	for s in stripers:
		string_name = string_name.replace(s, '')
		string_name = string_name.lstrip()
	return string_name


#------------------------------------------------END DEFINITIONS-------------------------------------------------------------------

arguments = sys.argv
path = arguments[1]
out_file = arguments[2]

#----------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------OPERATION START-------------------------------------------------------------------

#----------------------------------------------ADD GENBANK FILES-----------------------------------------------------------------
# ADD FILES: Open of file containing paths to genbank files
file_list = []

for dirpath, dirnames, filenames in os.walk(path):
		for filename in [f for f in filenames if f.endswith('.gbk')]:
			file_list.append(os.path.join(dirpath, filename))
#print(file_list)

#---------------------------------------------------------------------------------------------------------------------------------

#--------------------------PARSE GENBANK FILES---------------------------------
with open(out_file, 'w') as output_file:
	output_file.write('Strain\tGenome_Size\tGC_Content\tFeature_Count\n')

	for f in file_list:
		sequence = ''
		strain = ''
		gc_content = ''
		feature_count = 0
		genome_size = 0

		strain = f.split('/')[-1].replace('.gbk', '')
	
		for record in SeqIO.parse(f, 'genbank'):
			sequence = sequence + record.seq

			for feature in record.features: #Note: Need to find some methods to clean tables (e.g., Features) of rows with 'NA's only
				f_type = feature.type
				if f_type == 'CDS': # source information not necessary
					feature_count+=1

		genome_size = len(sequence)
		gc_content = round(GC(record.seq), 2)

		data = '\t'.join([strain, str(genome_size), str(gc_content), str(feature_count)]) + '\n'
		output_file.write(data)
		#print(strain, genome_size, gc_content, feature_count)
