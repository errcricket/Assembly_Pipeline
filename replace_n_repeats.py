'''
Author:	E. Reichenberger
Date:	9.21.2016

Purpose: The plasmid files (and possibly chromosome files) post-mauve contig alignment/reordering may have placed n's into the sequences (they are not there in the post-pilon files). Each file in the prokka directories (plasmid/chromosome) need to have the n's removed.

python replace_n_repeats.py $base_directory $chromosome_file $chromosome_directory $plasmid_files $plasmid_directory
'''

import sys
from shutil import copyfile
import os

arguments = sys.argv
base = arguments[1]
chromosome_file = arguments[2]
chromosome_directory = arguments[3]
plasmid_file = arguments[4]
plasmid_directory = arguments[5]

temp_plasmid = plasmid_directory + 'temp.fa'
temp_chromosome = chromosome_directory + 'temp.fa'

print(base)

def remove_Ns(fasta_file, temp_file):
	with open(fasta_file, 'r') as input_file, open(temp_file, 'w') as output_file:
		for line in input_file.readlines():
			if line.startswith('>'):
				output_file.write(line)
			else:
				line = line.replace('n', '')
				output_file.write(line)

	copyfile(temp_file, fasta_file)
	os.remove(temp_file)

remove_Ns(plasmid_file, temp_plasmid)
remove_Ns(chromosome_file, temp_chromosome)

'''
with open(plasmid_file, 'r') as file_p, open(temp_plasmid, 'w') as temp_p:
	for line in file_p.readlines():
		if line.startswith('>'):
			temp_p.write(line)
		else:
			line = line.replace('n', '')
			temp_p.write(line)

copyfile(temp_plasmid, plasmid_file)
os.remove(temp_plasmid)

B349/prokka/plasmid/temp.fa B349/prokka/chromosome/temp.fa
Traceback (most recent call last):
  File "replace_n_repeats.py", line 34, in <module>
    copyfile(temp_p, plasmid_file)
  File "/usr/local/anaconda3/lib/python3.5/shutil.py", line 97, in copyfile
    if _samefile(src, dst):
  File "/usr/local/anaconda3/lib/python3.5/shutil.py", line 82, in _samefile
    return os.path.samefile(src, dst)
  File "/usr/local/anaconda3/lib/python3.5/genericpath.py", line 90, in samefile
    s1 = os.stat(f1)
TypeError: argument should be string, bytes or integer, not _io.TextIOWrapper

shell returned 1
'''
