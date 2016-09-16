# Assembly_Pipeline

##Required Software Tools
Fastqc (Quality Control): http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
Trimmomatic (Illumina Trimming Tool): http://www.usadellab.org/cms/?page=trimmomatic
SPAdes (Draft Assembler): http://bioinf.spbau.ru/spades
BWA (Genome Mapper): http://bio-bwa.sourceforge.net/
Samtools (Alignment Manipulator): http://samtools.sourceforge.net/
Pilon (Draft Assembly Improver): https://github.com/broadinstitute/pilon/wiki
Mauve (Align/Move Contigs to Reference Genome): http://darlinglab.org/mauve/mauve.html
Prokka (Annotation): http://www.vicbioinformatics.com/software.prokka.shtml

##Required Files
Illumina Paired-End Fastq Files
Reference Genbank Files

##Required Set-Up
Make two subdirectories in your folder: 
* data
* reference\_files

##Running Instructions:
* Place all of your fastq files into the data directory
* Place your reference genbank files (must have .gbk extension) into reference_files directory
