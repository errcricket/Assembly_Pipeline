'''
Author:	E. Reichenberger	
Date:	11.3.2016

Purpose: Parse PHASTER output file to get start and stop position and name/function (ONLY from file). Note that the output file has not set delimiter. This step was done ahead of time: sed 's/  \+/\t/g' FILENAM
'''

def strip_it(string_name):
    string_name = str(string_name)
    stripers = ['[', ']', '\'', '"', ')', 'complement(']
    for s in stripers:
        string_name = string_name.replace(s, '')
        string_name = string_name.lstrip()
    return string_name


with open('modified_phage_regions_EDL933.txt', 'r') as input_file, open('BRIG_phage_regions_EDL933.txt', 'w') as output_file:
	output_file.write('#Start\tStop\tLabel\n')
	for line in input_file.readlines():
		if line.startswith('complement') or line[0].isdigit() and 'N/A' not in line:
			sLine = line.split('\t')
			location = sLine[0]

			start = strip_it(location.split('.')[0])
			stop = strip_it(location.split('.')[-1])

			description = sLine[1].split(';')[0]
			string = '\t'.join([start, stop, description]) + '\n'
			output_file.write(string)
