# Assembly_Pipeline

##Required Software Tools
* Fastqc (Quality Control): http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
* Trimmomatic (Illumina Trimming Tool): http://www.usadellab.org/cms/?page=trimmomatic
* SPAdes (Draft Assembler): http://bioinf.spbau.ru/spades
* BWA (Genome Mapper): http://bio-bwa.sourceforge.net/
* Samtools (Alignment Manipulator): http://samtools.sourceforge.net/
* Pilon (Draft Assembly Improver): https://github.com/broadinstitute/pilon/wiki
* Mauve (Align/Move Contigs to Reference Genome): http://darlinglab.org/mauve/mauve.html
* Prokka (Annotation): http://www.vicbioinformatics.com/software.prokka.shtml

##Required Files
* Illumina Paired-End Fastq Files
* Reference Genbank Files

##Required Set-Up
Make two subdirectories in your folder: 
* data (mkdir data)
* reference_files (mkdir reference_files)

##Running Instructions:
* Place all of your fastq files into the data sub-directory
* Place your reference genbank files (must have .gbk extension) into reference_files sub-directory
* Place run_assembly.sh into your folder
* Run pipeline: sh run_assembly.sh

##Additional Notes
* Example File Names (Illumina PE): B055_S5_R1.fastq.gz, B055_S5_R2.fastq.gz. This script operates with the assumption that the files are named in this format. The base (e.g., B055, B0267), will be used to create directories, and is the prefix for all subsequently named output files. As it is set now, the max number of base characters is 5, but this can be changed in the script.
* The name of the reference file(s) will need to be changed in the run_assembly.sh script to reflect the employed reference genbank files.

##Flow
If n number of Illumina PE files are placed in the data sub-directory...
* A sub-directory named after the base is created (n sub-directories will be created). Each sub-directory will have the following structure:

* base
	* fastqc_reports
	* trimmed_data
	* spades
	* fastqc_corrected_reports
	* bwa_indices
	* pilon
	* mauve_alignment
