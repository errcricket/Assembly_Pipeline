'''
Author:	E. Reichenberger
Date:	12.2.2016

Purpose: Fasta file headers are too long and are being cut-off during the ls-bsr analysis.
Pre:
fig|562.9858.peg.3603|   orf; Unknown function   [Escherichia coli strain SR    CC 1675 | 562.9858]
Post:
orf; Unknown function
'''

import sys
import os

arguments = sys.argv
in_file = arguments[1]
out_file = in_file.replace('.fasta', '_header.fasta')

count = 0
count_1 = 0
count_2 = 0
with open(out_file, 'w') as output_file:
	with open(in_file, 'r') as input_file:
		lines = input_file.readlines()
		for index, line in enumerate(lines):
			if line.startswith('>'):
				sLine = line.split('\t')
				header = '>' + sLine[1].replace(' ', '_') + '_' + str(index) + '\n'
#				if 'hypothetical_protein' in header:
#					old_string = 'hypothetical_protein'
#					new_string = 'hypothetical_protein_' + str(count)
#					header = header.replace(old_string, new_string)
#					count+=1
#
#				if 'Benzoate_transport_protein' in header:
#					old_string = 'Benzoate_transport_protein'
#					new_string = 'Benzoate_transport_protein_' + str(count_1)
#					header = header.replace(old_string, new_string)
#					count_1+=1
#
#				if 'Type_III_secretion_outermembrane_pore_forming_protein_(YscC,MxiD,HrcC,_InvG)' in header:
#					old_string = 'Type_III_secretion_outermembrane_pore_forming_protein_(YscC,MxiD,HrcC,_InvG)'
#					new_string = 'Type_III_secretion_outermembrane_pore_forming_protein_(YscC,MxiD,HrcC,_InvG)_' + str(count_2)
#					header = header.replace(old_string, new_string)
#					count_2+=1

				output_file.write(header)
				output_file.write(lines[index+1])
