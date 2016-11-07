def return_region(string):
	sString = string.split(' ')
	number = sString[2]

	return(number)

in_file = 'data/modified_phage_regions_EDL933.txt'
base = 'data/EDL933_phage_region_'
terminal = '.txt'

flag = ''
out_file = ''
phage_dic = {}

with open(in_file, 'r') as input_file:
	for line in input_file.readlines():
		if line.startswith('#### region'):
			flag = return_region(line)
			out_file = base + flag + terminal 
			
			if out_file not in phage_dic:
				phage_dic[out_file] = []

		if line.startswith('complement') or line[0].isdigit() and 'N/A' not in line:
			phage_dic[out_file].append(line)

for p in phage_dic:
	with open(p, 'w') as output_file:
		output_file.write('\t'.join(['CDS_POSITION', 'BLAST_HIT', 'EVALUE', 'prophage_PRO_SEQ']) + '\n')

		for z in phage_dic[p]:
			output_file.write(z)
