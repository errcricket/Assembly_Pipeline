#!/bin/bash

function make_phaster_fasta_files
{
	mkdir -p output

	for file in data/phaster_corpus.txt data/region_10.txt data/region_11.txt data/region_12.txt data/region_13.txt data/region_14.txt data/region_15.txt data/region_16.txt data/region_17.txt data/region_18.txt data/region_19.txt data/region_1.txt data/region_20.txt data/region_2.txt data/region_3.txt data/region_4.txt data/region_5.txt data/region_6.txt data/region_7.txt data/region_8.txt data/region_9.txt 
	do
		python extract_gene.py data/CP008957.gbk $file
	done
#	python extract_gene.py data/CP008957.gbk data/phaster_corpus.txt
#	python extract_gene.py data/CP008957.gbk data/region_10.txt
#	python extract_gene.py data/CP008957.gbk data/region_11.txt
#	python extract_gene.py data/CP008957.gbk data/region_12.txt
#	python extract_gene.py data/CP008957.gbk data/region_13.txt
#	python extract_gene.py data/CP008957.gbk data/region_14.txt
#	python extract_gene.py data/CP008957.gbk data/region_15.txt
#	python extract_gene.py data/CP008957.gbk data/region_16.txt
#	python extract_gene.py data/CP008957.gbk data/region_17.txt
#	python extract_gene.py data/CP008957.gbk data/region_18.txt
#	python extract_gene.py data/CP008957.gbk data/region_19.txt
#	python extract_gene.py data/CP008957.gbk data/region_1.txt
#	python extract_gene.py data/CP008957.gbk data/region_20.txt
#	python extract_gene.py data/CP008957.gbk data/region_2.txt
#	python extract_gene.py data/CP008957.gbk data/region_3.txt
#	python extract_gene.py data/CP008957.gbk data/region_4.txt
#	python extract_gene.py data/CP008957.gbk data/region_5.txt
#	python extract_gene.py data/CP008957.gbk data/region_6.txt
#	python extract_gene.py data/CP008957.gbk data/region_7.txt
#	python extract_gene.py data/CP008957.gbk data/region_8.txt
#	python extract_gene.py data/CP008957.gbk data/region_9.txt
}

function get_ls_bsr_matrices
{
	#citation: Altschul SF, Madden TL, Schaffer AA, Zhang J, Zhang Z, Miller W, and Lipman DJ. 1997. Gapped BLAST and PSI-BLAST: a new generation of protein database search programs. Nucleic Acids Res 25:3389-3402
	mkdir -p phaster_results

	for file in output/phaster_corpus.fasta output/region_12.fasta output/region_15.fasta output/region_18.fasta output/region_20.fasta output/region_4.fasta output/region_7.fasta output/region_10.fasta output/region_13.fasta output/region_16.fasta output/region_19.fasta output/region_2.fasta output/region_5.fasta output/region_8.fasta output/region_11.fasta output/region_14.fasta output/region_17.fasta output/region_1.fasta output/region_3.fasta output/region_6.fasta output/region_9.fasta
	do
		region="${file/output\/}"
		region="${region/.fasta/}"
		count="${region/region_/}"
		echo $region $count

		python /usr/local/LS-BSR/ls_bsr.py -d /home/cricket/Projects/Assembly_Pipeline/ls_bsr/fasta_files -p 30 -c vsearch -y $count -x $region -g $file

		mv *.txt phaster_results/.
	done
}

function plot_images
{
phaster_results/region_20_bsr_matrix.txt
	mkdir -p images/
	for file in phaster_results/phaster_corpus_bsr_matrix.txt phaster_results/region_10_bsr_matrix.txt phaster_results/region_11_bsr_matrix.txt phaster_results/region_12_bsr_matrix.txt phaster_results/region_13_bsr_matrix.txt phaster_results/region_14_bsr_matrix.txt phaster_results/region_15_bsr_matrix.txt phaster_results/region_16_bsr_matrix.txt phaster_results/region_17_bsr_matrix.txt phaster_results/region_18_bsr_matrix.txt phaster_results/region_19_bsr_matrix.txt phaster_results/region_1_bsr_matrix.txt phaster_results/region_20_bsr_matrix.txt phaster_results/region_2_bsr_matrix.txt phaster_results/region_3_bsr_matrix.txt phaster_results/region_4_bsr_matrix.txt phaster_results/region_5_bsr_matrix.txt phaster_results/region_6_bsr_matrix.txt phaster_results/region_7_bsr_matrix.txt phaster_results/region_8_bsr_matrix.txt phaster_results/region_9_bsr_matrix.txt 
	do 
		image_file="${file/phaster_results/images}"
		image_file="${image_file/txt/png}"
		image_file="${image_file/_bsr_matrix/}"
		region="${image_file/images\//}"
		region="${region/.png/}"
		region="${region/region_/}"
		#echo $file $image_file	$region

		Rscript plot_phage_regions.R $file $image_file $region
	done
}

#make_phaster_fasta_files
#get_ls_bsr_matrices
plot_images
