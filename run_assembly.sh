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

#This is for IGV viewing and has been placed here to take advantage of the reference file assignment.
function get_sorted_bam_files
{
	export bwa_directory=$base_directory"/bwa_indices/"
	export draft_assembly_file=$bwa_directory$base_directory".fa"
	export sam_file=$base_directory".sam"
	export bam_file=$base_directory".bam"
	export sorted_prefix=$base_directory"_sorted"
	export sorted_bam=$sorted_prefix".bam"
	export sorted_bai=$sorted_prefix".bai"
	export home_dir=/home/cricket/Projects/Assembly_Pipeline/

    mkdir -p $bwa_directory 
	ln -sf $home_dir$spades_directory"scaffolds.fasta" $draft_assembly_file

	cd $bwa_directory

	#This is for the .sai files
	bwa aln -t 28 -f $base_directory"_1P.sai" $ref_file $corrected_forward_file 
	bwa aln -t 28 -f $base_directory"_2P.sai" $ref_file $corrected_reverse_file 

	#function create_sam_alignment
	bwa mem -P -t 26 $ref_file Minus(fasta) $corrected_forward_file $corrected_reverse_file > $sam_file

	#Convert from SAM to BAM format
	samtools view -b -S -o $bam_file $sam_file

	#bam_sort_index
	samtools sort $bam_file $sorted_bam 
	samtools index $sorted_bam 

#	bwa index -p $base_directory -a is $base_directory".fa"
#	bwa mem -t 20 $base_directory  $home_dir$corrected_forward_file $home_dir$corrected_reverse_file > $sam_file
#	samtools view -bS $sam_file | samtools sort - $sorted_prefix
#	samtools index $sorted_bam $sorted_bai 
#	
	cd -
}
#----------------------------------------------------------------------------------------------------------------------------------------------------


function separate_plasmid_chromosome
{
	export prokka_directory=$base_directory"/prokka/"
	export chromosome_directory=$prokka_directory"chromosome/"
	export plasmid_directory=$prokka_directory"plasmid/"

	mkdir -p $prokka_directory
	mkdir -p $chromosome_directory
	mkdir -p $plasmid_directory
	
	final_assembly=$prokka_directory$base_directory"_formatted.fa"

	#for dir in ${mauve_directory[*]}
	#do
	#	assemblies=($mauve_directory"*/*.fasta")
	#	for assembly in ${assemblies[*]}
	#	do
	#		fasta_formatter -i $assembly -o $final_assembly
	#	done
	#done

	contig_file=plasmid_contig_list.txt
	#python separate_plasmids_chromosomes.py $base_directory $final_assembly $contig_file $chromosome_directory $plasmid_directory
}
#----------------------------------------------------------------------------------------------------------------------------------------------------


function remove_n_repeats
{
	export plasmid_file=$plasmid_directory$base_directory"_P.fa"
	export chromosome_file=$chromosome_directory$base_directory"_C.fa"
	#python replace_n_repeats.py $base_directory $chromosome_file $chromosome_directory $plasmid_file $plasmid_directory
}
#----------------------------------------------------------------------------------------------------------------------------------------------------


function align_plasmids
{
	export plasmid_alignment_directory=$plasmid_directory"mauve/"

	mkdir -p $plasmid_alignment_directory

	if [ $base_directory != B055 ] #|| [ $base_directory == B204 ]
	then
		export ref_file=reference_files/CP008958.gbk
	fi

	#java -Xmx16G -cp /usr/local/Mauve/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output $plasmid_alignment_directory -ref $ref_file -draft $plasmid_file 
}
#----------------------------------------------------------------------------------------------------------------------------------------------------


function separate_plasmid_contigs
{

	export plasmid_final_assembly_directory=$plasmid_directory"final_assembly/"
	mkdir -p $plasmid_final_assembly_directory

	plasmid_final_assembly=$plasmid_final_assembly_directory$base_directory"_P.fa"

	for dir in ${plasmid_alignment_directory[*]}
	do
		assemblies=($plasmid_alignment_directory"alignment*/"$base_directory"_P.fa.fas")

		for assembly in ${assemblies[*]}
		do
			fasta_formatter -i $assembly -o $plasmid_final_assembly
		done
	done

	contig_file=aligned_plasmid_contig_list.txt

	if [ $base_directory == B296 ]
	#if [ $base_directory != B055 ]
	then
		python separate_plasmids_chromosomes.py $base_directory $final_assembly $contig_file 0 $plasmid_final_assembly_directory
		echo $base_directory
		echo $final_assembly
		echo $contig_file
		echo $plasmid_final_assembly_directory

	fi
}
#----------------------------------------------------------------------------------------------------------------------------------------------------


function call_prokka
{
	if [ $base_directory == B296 ]
	then
		prokka --outdir $chromosome_directory --force --prefix $base_directory --locustag L --increment 1 --compliant --centre C --genus Escherichia --species coli --strain $base_directory --kingdom Bacteria --cpus 30 --rfam $chromosome_file 
	fi

	if [ $base_directory == B296 ]
	#if [ $base_directory != B055 ]
	then
		prokka --outdir $plasmid_directory --force --prefix $base_directory --locustag L --increment 1 --compliant --centre C --genus Escherichia --species coli --strain $base_directory --kingdom Bacteria --cpus 28 --rfam $plasmid_final_assembly 
	fi
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

function align_discarded_contigs
{
	
	#export plasmid_directory=$prokka_directory"plasmid/"
	discarded_contig_file=$plasmid_final_assembly_directory$base_directory"_discarded_contigs.fa"
	export discarded_plasmid_alignment_directory=$plasmid_directory"mauve/plasmid_2"

	mkdir -p $discarded_plasmid_alignment_directory

	if [ $base_directory != B055 ] #|| [ $base_directory == B204 ]
	then
		export ref_file=reference_files/NC_002127.gbk
	fi

	java -Xmx16G -cp /usr/local/Mauve/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output $discarded_plasmid_alignment_directory -ref $ref_file -draft $discarded_contig_file 
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

function blast_discarded_contigs
{
	contig_file=$plasmid_final_assembly_directory$base_directory"_discarded_contigs.fa"
	blast_results_file=$plasmid_final_assembly_directory$base_directory"_blast_results.txt"
	#echo $contig_file
	#echo $blast_results_file
	blastn -task blastn -query $contig_file -db nt -outfmt 6 -num_alignments 1 -num_threads 22 -out $blast_results_file 
	#blastn -outfmt 6 -query /root/cricket/Projects/Assembly_Pipeline/BRIG/scratch/B296.gbk.fna -db /root/cricket/Projects/Assembly_Pipeline/BRIG/scratch/CP008957.gbk.fna -out /root/cricket/Projects/Assembly_Pipeline/BRIG/scratch/B296.gbk.fnaVsCP008957.gbk.fna.tab   -task blastn 

	#blastn -task blastn -query $contig_file -db nr -outfmt 6 -num_alignments 1 -max_target_seqs 1 -num_threads 22 -out $blast_results_file 
}
#----------------------------------------------------------------------------------------------------------------------------------------------------


function identify_prophage_regions
{
	wget --post-file=B055.gbk http://phaster.ca/phaster_api -O B055_phaster
	#  1 {"job_id":"ZZ_cf16c43cf6","status":"You're next!..."}

	wget "http://phaster.ca/phaster_api?acc=ZZ_7aee5a5db4" -O temp
	wget phaster.ca/submissions/ZZ_7aee5a5db4.zip
}
#----------------------------------------------------------------------------------------------------------------------------------------------------

function align_chromosome
{
	corpus_assembly=corpus_assembly/
	corpus_file=corpus_assembly
	corpus_tree=corpus.tree
	corpus_backbone=corpus.backbone
	mkdir -p $corpus_assembly

	cd $corpus_assembly
	progressiveMauve --output=$corpus_file --output-guide-tree=$corpus_tree --backbone-output=$corpus_backbone ../reference_files/CP008957.gbk ../final_fasta/chromosome/B201.fasta ../final_fasta/chromosome/B0246.fasta ../final_fasta/chromosome/B241.fasta ../final_fasta/chromosome/B264.fasta ../final_fasta/chromosome/B265.fasta ../final_fasta/chromosome/B271.fasta ../final_fasta/chromosome/B0247.fasta ../final_fasta/chromosome/B0249.fasta ../final_fasta/chromosome/B202.fasta ../final_fasta/chromosome/B349.fasta ../final_fasta/chromosome/B204.fasta ../final_fasta/chromosome/B250.fasta ../final_fasta/chromosome/B301.fasta ../final_fasta/chromosome/B0245.fasta ../final_fasta/chromosome/B309.fasta ../final_fasta/chromosome/B263.fasta ../final_fasta/chromosome/B244.fasta ../final_fasta/chromosome/B269.fasta ../final_fasta/chromosome/B311.fasta ../final_fasta/chromosome/B273.fasta ../final_fasta/chromosome/B296.fasta ../final_fasta/chromosome/B266.fasta ../final_fasta/chromosome/B307.fasta ../final_fasta/chromosome/B306.fasta ../final_fasta/chromosome/B251.fasta ../final_fasta/chromosome/B055.fasta

	cd -
}

function count_contigs
{
	discarded_plasmid_alignment_directory=$base_directory"/prokka/plasmid/mauve/plasmid_2/"
	#alignment2 /B0245_discarded_contigs.fa_contigs.tab 
	#discarded_plasmid_alignment_directory=$base_directory"/prokka/plasmid/mauve/plasmid_2/alignment2 /B0245_discarded_contigs.fa_contigs.tab 
	#echo $plasmid_alignment_directory
	for dir in ${discarded_plasmid_alignment_directory[*]}
    do
        assemblies=($discarded_plasmid_alignment_directory"alignment*/"$base_directory"_discarded_contigs.fa.fas")

        for assembly in ${assemblies[*]}
        do
			if [ $base_directory != 'B055' ]
			then
				a=test
				#echo $assembly
				#wc -l $assembly
			fi
		done
	done
	#/home/cricket/Projects/Assembly_Pipeline/B0245/prokka/plasmid/mauve/plasmid_2/alignment2/B0245_discarded_contigs.fa_contigs.tab 
	#$discarded_plasmid_alignment_directory #=$plasmid_directory"mauve/plasmid_2"
}



#-----------------Function Calls--------------------

export reference_indices=reference_mapping_files/
mkdir -p $reference_indices

#index reference files (for mapping -- this need only be done once)
if [ ! -f reference_files/CP008957.sa ]; then
	bwa index reference_files/CP008957.fasta #<- CP008957.fasta.bwt CP008957.fasta.pac CP008957.fasta.ann CP008957.fasta.amb CP008957.fasta.sa 
fi

if [ ! -f reference_files/U00096.sa ]; then
	bwa index reference_files/U00096.fasta #<- U00096.fasta.bwt U00096.fasta.pac U00096.fasta.ann U00096.fasta.amb U00096.fasta.sa 
fi

if [ ! -f reference_files/CP008958.sa ]; then
	bwa index reference_files/CP008958.fasta #<- CP008958.fasta.bwt CP008958.fasta.pac CP008958.fasta.ann CP008958.fasta.amb CP008958.fasta.sa 
fi

#cd $reference_indices
#pwd
#bwa index -p CP008957 -a is ../reference_files/CP008957.fasta
#bwa index -p U00096 -a is ../reference_files/U00096.fasta
#bwa index -p CP008958 -a is ../reference_files/CP008958.fasta
#cd -

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

		#mkdir -p B204/mauve/
		#mkdir -p B204/mauve/EC4115/
		#mkdir -p B204/mauve/Sakai/
		#mkdir -p B204/mauve/EDL933/
		#mkdir -p B204/mauve/K12/

		#java -Xmx16G -cp /usr/local/Mauve/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output B204/mauve/EC4115 -ref reference_files/CP001164.gbk  -draft B204/pilon/B204.fasta 
		#java -Xmx16G -cp /usr/local/Mauve/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output B204/mauve/Sakai -ref reference_files/NC_002695.gbk  -draft B204/pilon/B204.fasta 
		#java -Xmx16G -cp /usr/local/Mauve/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output B204/mauve/EDL933 -ref reference_files/CP008957.gbk  -draft B204/pilon/B204.fasta 
		#java -Xmx16G -cp /usr/local/Mauve/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output B204/mauve/K12 -ref reference_files/U00096.gbk  -draft B204/pilon/B204.fasta 

	#create quality report using fastqc 
		#run_fastqc

	#trim paired-end reads using trimmomatic
		#run_trimmatic

	#de-novo assembly using SPAdes
		#run_spades

	#create quality report on corrected & trimmed fastq files using fastqc 
		#run_fastqc_corrected 

	#create sam/bam alignment (sorted) files
		#get_sorted_bam_files

	#improve draft assembly with Pilon
		#run_pilon

	#align second draft assembly to reference using Mauve
		#mauve_alignment

	#Separate plasmid from chromosome, this copies the final & formatted assembly files to prokka directory
	##NOTE: Prior to this step, alignments must be manually inspected for last chromosome node
		#separate_plasmid_chromosome

	#Remove n's from plasmid and chromosome files
		#remove_n_repeats

	#align plasmids to ELD933 plasmid
		#align_plasmids

	#Separate non-aligned contigs from plasmid files
	##NOTE: Prior to this step, final alignments must be manually inspected for last plasmid node
	### to find last aligned Node, and place that info in output file.
		#separate_plasmid_contigs
	
	#Annotate files
		#call_prokka

	#Align discarded contigs (to smaller plasmid)
		#align_discarded_contigs

	#Blast discarded contigs
		#blast_discarded_contigs

	#Run PHASTER
		#identify_prophage_regions

	#Multi-sequence alignment for chromosomes
		#align_chromosome

	#Count contigs to rule out cross-contamination
		#count_contigs	
}

#java -cp readseq.jar run NC_012967.1.gbk -f GFF -o NC_012967.1.gbk.gff <- convert genbank to gff GFF2 <- not good
