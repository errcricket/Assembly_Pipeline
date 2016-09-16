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
* Example File Names (Illumina PE): B055_S5_R1.fastq.gz, B055_S5_R2.fastq.gz. This script operates with the assumption that the files are named in this format (up to 5 characters for strain name (e.g., B055, B0267), as these first 5 characters will make up the base name).
* The name of the reference file(s) will need to be changed in the run_assembly.sh script to reflect the employed reference genbank files.
