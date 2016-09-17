#!/bin/bash 

#-------------------------------------------------------------------------------------------------------------------------------------------------
function run_fastqc #run fastqc to check for quality
{
	#echo $forward_file
	export reverse_file="${forward_file/R1/R2}"
	export fastqc_directory=$base_directory"/fastqc_reports"	
	mkdir -p $fastqc_directory

	#fastqc $forward_file -o $fastqc_directory
	#fastqc $reverse_file -o $fastqc_directory
}
#--------------------------------------------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------------------------------------------
function run_trimmatic
{
	export trimmed_directory=$base_directory"/trimmed_data/"	
	mkdir -p $trimmed_directory

	trimmed_name="${forward_file/.fastq.gz/_filtered.fastq.gz}"
	export trimmed_name=$trimmed_directory$base_directory".fq.gz"
	#echo $trimmed_name

	#echo $forward_file $reverse_file
	#java -jar /usr/local/trimmomatic/trimmomatic-0.36.jar PE -threads 28 -phred33 $forward_file $reverse_file -baseout $trimmed_name LEADING:3 TRAILING:3 SLIDINGWINDOW:4:26 MINLEN:40
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------
function run_spades
{
	export spades_directory=$base_directory"/spades/"	
	mkdir -p $spades_directory

	spades_forward_file="${trimmed_name/.fq.gz/_1P.fq.gz}"
	spades_reverse_file="${trimmed_name/.fq.gz/_2P.fq.gz}"
	
	#echo $spades_forward_file $spades_reverse_file

	#time spades.py --careful -1 $spades_forward_file -2 $spades_reverse_file -t 26 -o $spades_directory 
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------
function run_fastqc_corrected #run fastqc to check for quality
{
	export fastqc_corrected_directory=$base_directory"/fastqc_corrected_reports/"	
	mkdir -p $fastqc_corrected_directory 

	ending=".00.0_0.cor.fastq.gz"
	spades_corrected_base=$spades_directory"corrected/"
	
	export corrected_forward_file=$spades_corrected_base$base_directory"_1P.fq"$ending
	export corrected_reverse_file="${corrected_forward_file/1P/2P}"

	#echo $corrected_forward_file 
	#echo $corrected_reverse_file

	#fastqc $corrected_forward_file -o $fastqc_corrected_directory 
	#fastqc $corrected_reverse_file -o $fastqc_corrected_directory
}
#----------------------------------------------------------------------------------------------------------------------------------------------------


function get_sorted_bam_files
{
	export bwa_directory=$base_directory"/bwa_indices/"
	export draft_assembly_file=$bwa_directory$base_directory".fa"
	export sam_file=$base_directory".sam"
	export sorted_prefix=$base_directory"_sorted"
	export sorted_bam=$base_directory"_sorted.bam"
	export sorted_bai=$base_directory"_sorted.bai"
	home_dir=/home/cricket/Projects/Assembly_Pipeline/


    mkdir -p $bwa_directory 
	ln -sf $home_dir$spades_directory"scaffolds.fasta" $draft_assembly_file

#	cd $bwa_directory
#
#	bwa index -p $base_directory -a is $base_directory".fa"
#	bwa mem -t 20 $base_directory  $home_dir$corrected_forward_file $home_dir$corrected_reverse_file > $sam_file
#	samtools view -bS $sam_file | samtools sort - $sorted_prefix
#	samtools index $sorted_bam $sorted_bai 
#	
#	cd -
}
#----------------------------------------------------------------------------------------------------------------------------------------------------


function run_pilon
{
	export pilon_directory=$base_directory"/pilon/"
	mkdir -p $pilon_directory
	sorted_bam=$bwa_directory$sorted_bam

	#java -Xmx16G -jar /usr/local/pilon.jar --threads 28 --genome $draft_assembly_file --frags $sorted_bam --changes --tracks --output $base_directory --outdir $pilon_directory 
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

function mauve_alignment
{
	export mauve_directory=$base_directory"/mauve/"
	mauve_input_file=$pilon_directory$base_directory".fasta"

	mkdir -p $mauve_directory

	if [ $base_directory == B055 ]
	then
		export ref_file=reference_files/U00096.gbk
		export ref=_K12
	else
		export ref_file=reference_files/CP008957.gbk
		export ref=_EDL933
	fi

	mauve_prefix=$base_directory$ref

	#java -Xmx16G -cp /usr/local/Mauve/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output $mauve_directory -ref $ref_file -draft $mauve_input_file 
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

function copy_final_assembly
{
	#This will copy over fasta files to end up with the last alignment fasta file
	export IGV_directory=$base_directory"/IGV/"
	mkdir -p $IGV_directory

	final_assembly=$IGV_directory$base_directory".fa"

#	for dir in ${mauve_directory[*]}
#	do
#		assemblies=($mauve_directory"*/*.fasta")
#		for assembly in ${assemblies[*]}
#		do
#			cp $assembly $final_assembly
#		done
#	done
}

#----------------------------------------------------------------------------------------------------------------------------------------------------


function index_final_assembly
{
	export final_assembly_file=$IGV_directory$base_directory".fa"
	echo $final_assembly_file

	cd $IGV_directory

	#bwa index -p $base_directory -a is $base_directory".fa"
	bwa mem -t 20 $base_directory  $home_dir$corrected_forward_file $home_dir$corrected_reverse_file > $sam_file
	samtools view -bS $sam_file | samtools sort - $sorted_prefix
	samtools index $sorted_bam $sorted_bai 
	
	cd -
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

#-----------------Function Calls--------------------
sequence_file_list=(data/*R1.fastq.gz)
for forward_file in ${sequence_file_list[*]}
{
	#set initial forward fastq file
		export forward_file

	#set base directory
		base_directory="${forward_file/data\//}"
		base_directory=${base_directory:0:5}
		export base_directory="${base_directory/_/}"

		mkdir -p $base_directory

	#create quality report using fastqc 
		run_fastqc

	#trim paired-end reads using trimmomatic
		run_trimmatic

	#de-novo assembly using SPAdes
		run_spades

	#create quality report on corrected & trimmed fastq files using fastqc 
		run_fastqc_corrected 

	#create sam/bam alignment (sorted) files
		get_sorted_bam_files

	#improve draft assembly with Pilon
		run_pilon

	#align second draft assembly to reference using Mauve
		mauve_alignment

	#copy final assembly files to IGV directory
		copy_final_assembly

	#create index files of final assembly
		index_final_assembly
}
