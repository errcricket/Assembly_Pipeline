'''
Created:	E. Reichenberger
Date:	11.20.2015

Purpose: This script, using start/stop position of gene within genome will find extract the nucleotide sequence from the ORIGIN sequence and write the header and read to output file. 

Input: Reference genbank file and detail.txt output file from Phaster
Output: multi_sequence_phaster.fasta 
Call: python extract_gene.py detail.txt CP008957.gbk

NOTE: Should split into regions first
'''

import os
import sys
import re
import Bio
from Bio import GenBank
from Bio import SeqIO
from Bio import SeqFeature
from Bio.GenBank import Record
from Bio.GenBank.Record import Record
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import generic_dna, generic_protein
from Bio.SeqFeature import Reference, SeqFeature, FeatureLocation
from Bio.Alphabet import IUPAC

arguments = sys.argv
genbank_file = arguments[1] 
phaster_file = arguments[2] 

out_file = phaster_file.replace('.txt', '.fasta')
out_file = out_file.replace('data', 'output')

record = next(SeqIO.parse(genbank_file, 'genbank'))
sequence = record.seq

def get_aminoAcid(nucleotide_sequence, start_position, stop_position, complement_TF, r_complement_TF):
	gene_sequence = ''

	if complement_TF == False and r_complement_TF == False:
		gene_sequence = str(nucleotide_sequence[start:stop]) + '\n'
	if complement_TF == True and r_complement_TF == False:
		gene_sequence = str(nucleotide_sequence[start:stop].complement()) + '\n'
	if complement_TF == True and r_complement_TF == True:
		gene_sequence = str(nucleotide_sequence[start:stop].reverse_complement()) + '\n'

	return(gene_sequence)

with open(out_file, 'w') as output_file:
	with open(phaster_file, 'r') as input_file:
		for line in input_file.readlines():	
			if line[0].isdigit() or line.startswith('complement') or line.startswith('reverse_complement'):
				line = re.sub('  +','\t', line) #replace multiple spaces with tab
				sLine = line.split('\t') #split line for headers & start/stop position

				complement = ''
				reverse_complement = ''

				location = sLine[0]
				if 'complement' in location and 'reverse' not in location:
					complement = True
					location = location.replace('complement(', '')
					location = location.replace(')', '')
				elif 'complement' in location and 'reverse' in location:
					complement = False
					reverse_complement = True
				elif
					complement = False

				start = int(location.split('.')[0])
				stop = int(location.split('.')[-1])

				header = '>' + sLine[1] + '_' + location #adding location makes each header unique
				header = header.replace('; ', '_')
				header = header.replace(': ', '_')
				header = header.replace(' ', '_') + '\n'
	
				Gene = get_aminoAcid(sequence, start, stop, complement, reverse_complement)
				output_file.write(header)
				output_file.write(Gene)

'''
protein="MDNTQKYAAIDLKSFYASVECILRKLDPLNTNLVVADESRTEKTICLAVSPALRSYNISGRLRLFELIQKVKTINYERLKIAKYFSAKSYNHLELINNPNLELDYIVAKPRMSTYIDYSSKIYSIYLKYFDPKDIHIYSIDEVFIDLTPYIKHYKLSADKLIENILFEILKTTQITATAGIGTNLYLAKIAMDILAKKQNINKDGLCIGYLDEMLYRRKLWQHTPINDFWRIGKGYATKLKSIGINNMGDLARYSLNNEDKLYQIFGVNTELLIDHAWGFESCTMQAIKEYKSKHISKVMAKVLPKPYSFKKARNMLKEIVDHMVRAN"

gene_nucleotide = ''
start  = 49163 
#stop = 50149 
stop = 50147 
nameOut = 'ultraV_gene.fasta'
indices = [-2, -1, 0, 1, 2]
record = next(SeqIO.parse(genome_file, 'genbank'))
sequence = record.seq
Gene = get_aminoAcid(sequence, protein, start, stop, nameOut)
print(Gene[60:200])

#print(protein)
print(len(Gene))
record = next(SeqIO.parse('CampyRM1529/prokka_output/RM1529.gbk', 'genbank'))
sequence_2 = record.seq

#if str(Gene)[26:296] in enumerate(str(sequence_2)):
if str(Gene)[26:296] in str(sequence_2):

#if str(Gene)[800:900] in str(sequence_2):
#if str(Gene)[100:296] in str(sequence_2):
	print('IT IS HERE')
else:
	print('IT AIN\'T HERE')

#for m in re.finditer(str(Gene[60:296]), str(sequence_2)):
for m in re.finditer(str(Gene[60:296]), str(sequence_2)):
		print(m.start(), m.end())

print(protein)
'''
