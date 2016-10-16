'''
Author:	E. Reichenberger
Date:	10.16.2016

Purpose: Split gene names (accession_gene) by '_' and reorder them (gene_accession) so that the rows can be ordered.
'''

file_in = 'VIR_bsr_matrix_short.txt'
file_out = 'VIR_bsr_matrix_short_gene_order.txt'

line_list = []

with open(file_out, 'w') as output_file:
	with open(file_in, 'r') as input_file:
		output_file.write(input_file.readline())
	
		for line in input_file.readlines():
			sLine = line.split('\t')
			identifiers = sLine[0]
			identifier = identifiers.split('_')
			accession = ''

			if identifiers.startswith('EDL933'):
				accession = identifier[0] + '_' + identifier[1]
				gene_description = '_'.join(identifier[2:])
				

			else:
				accession = identifier[0]
				gene_description = '_'.join(identifier[1:])

			gene_accession = str(gene_description) + '_' + accession	
			#print(line.split('\t')[0], '\t', gene_accession)

			new_line = '\t'.join(sLine[1:])
			output_line = '\t'.join([gene_accession, new_line])

			line_list.append(output_line)

			line_list.sort()
			for l in line_list:
				output_file.write(l)
