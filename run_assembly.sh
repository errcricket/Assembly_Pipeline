#!/bin/bash 

#-------------------------------------------------------------------------------------------------------------------------------------------------
function run_fastqc #run fastqc to check for quality
{
	echo $forward_file
	export reverse_file="${forward_file/R1/R2}"
	export fastqc_directory=$base_directory"/fastqc_reports"	
	mkdir -p $fastqc_directory

	fastqc $forward_file -o $fastqc_directory
	fastqc $reverse_file -o $fastqc_directory
#	mkdir -p fastqc_reports
#
#	sequence_file_list=(data/*fastq.gz)
#	for f in ${sequence_file_list[*]}
#	do
#
#		#echo $f, $filteredF_name, $clipped_name, $trimmed_name
#		#fastqc $f -o fastqc_reports
#	done
}
#--------------------------------------------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------------------------------------------
function run_trimmatic
{
	echo run_trimmatic
#	mkdir -p trimmed_data
#	sequence_file_list=(temp/*R1.fastq.gz)
#
#	for file in ${sequence_file_list[*]}
#	do
#		file_out="${file/R1/R2}"
#		trimmed_name="${file/.fastq.gz/_filtered.fastq.gz}"
#		trimmed_name="${trimmed_name/data/trimmed_data}"
#		echo $file $file_out $trimmed_name
#		
#		#java -jar /usr/local/trimmomatic/trimmomatic-0.36.jar PE -threads 26 -phred33 -basein $file -baseout $trimmed_name LEADING:3 TRAILING:3 SLIDINGWINDOW:4:26 MINLEN:40
#		java -jar /usr/local/trimmomatic/trimmomatic-0.36.jar PE -threads 26 -phred33 $file $file_out -baseout $trimmed_name LEADING:3 TRAILING:3 SLIDINGWINDOW:4:26 MINLEN:40
#	done
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------
function test_spades
{
	echo test_spades
#	mkdir -p temp/spades
#	time spades.py --careful -1 temp/B055_S5_R1_filtered_1P.fastq.gz -2 temp/B055_S5_R1_filtered_2P.fastq.gz -t 28 -o temp/spades/
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------
function run_fastqc_corrected #run fastqc to check for quality
{
	echo run_fastqc_corrected
#	mkdir -p temp/spades/fastqc_reports
#
#	for f in temp/spades/corrected/B055_S5_R1_filtered_1P.fastq.00.0_0.cor.fastq.gz temp/spades/corrected/B055_S5_R1_filtered_2P.fastq.00.0_0.cor.fastq.gz 
#	do
#
#		fastqc $f -o temp/spades/fastqc_reports
#	done
}
#----------------------------------------------------------------------------------------------------------------------------------------------------


function align_reads
{
	echo align_reads
#    mkdir -p bwa_indices #this will hold index files from bowtie2-build	
#	cd bwa_indices
#
#	cp ../temp/spades/scaffolds.fasta B055.fa 
#
#	bwa index -p B055 -a is B055.fa
#	bwa mem -t 20 B055  ../temp/spades/corrected/B055_S5_R1_filtered_1P.fastq.00.0_0.cor.fastq.gz ../temp/spades/corrected/B055_S5_R1_filtered_2P.fastq.00.0_0.cor.fastq.gz > B055.sam
#
#	samtools view -bS B055.sam | samtools sort - B055_sorted
#	samtools index B055_sorted.bam B055_sorted.bai
#	cd -
}
#----------------------------------------------------------------------------------------------------------------------------------------------------


function run_pilon
{
	echo run_pilon
#	mkdir -p pilon
#	java -Xmx16G -jar /usr/local/pilon.jar --threads 28 --genome bwa_indices/B055.fa --frags bwa_indices/B055_sorted.bam --changes --tracks --output B055 --outdir pilon/ 
#	
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

function mauve_align
{
	echo mauve_align
#	mauve_output_dir=mauve_alignment/
#	mkdir -p $mauve_output_dir
#	cd $mauve_output_dir
#
#	ln -sf ../../Reference_Files/Ecoli_EC4115.gbk .
#	ln -sf ../../Reference_Files/Ecoli_EDL933.gbk .
#	ln -sf ../../Reference_Files/Ecoli_Sakai.gbk .
#	ln -sf ../../Reference_Files/Ecoli_K12.gbk .
#	ln -sf ../pilon/B055.fasta
#
#	#for ref in EC4115 #EDL933 Sakai
#	for ref in K12 
#	{
#		mauve_prefix="B055_"$ref
#		mkdir -p $mauve_prefix
#		ref_file="Ecoli_"$ref".gbk"
#		#echo $ref_file
#
#		#progressiveMauve --output=$mauve_prefix"/"$mauve_prefix".fasta" --disable-backbone $ref_file B055.fasta 
#		java -Xmx900m -cp /usr/local/Mauve/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output $mauve_prefix"/"$mauve_prefix"_reordered" -ref $ref_file -draft B055.fasta
#	}
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

#-----------------Function Calls--------------------
sequence_file_list=(data/*R1.fastq.gz)
for forward_file in ${sequence_file_list[*]}
{
	export forward_file
	#set base directory
	base_directory="${forward_file/data\//}"
	base_directory=${base_directory:0:5}
	export base_directory="${base_directory/_/}"

	mkdir -p $base_directory
	#echo $base_directory

	#fastqc reports
	#export reverse_file="${forward_file/R1/R2}"
	trimmed_name="${forward_file/.fastq.gz/_filtered.fastq.gz}"
	export trimmed_name="${trimmed_name/data/trimmed_data}"
	#echo $file $file_out $trimmed_name

#	export fastqc_directory=$base_directory"/fastqc_reports"	
	#echo $fastqc_directory
#	mkdir -p $fastqc_directory

	run_fastqc




#	run_trimmatic
#	test_spades
#	run_fastqc_corrected 
#	align_reads
#	run_pilon
#	mauve_align
}
