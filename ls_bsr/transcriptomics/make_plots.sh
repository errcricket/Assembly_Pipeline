#!/bin/bash

function alter_headers
{
	for file in gene_candidates/B201_DL3Z3_aa.fasta  gene_candidates/B241_DL3Z3_aa.fasta gene_candidates/B201_DL3Z3_nt.fasta  gene_candidates/B241_DL3Z3_nt.fasta gene_candidates/B201_UL3Z3_aa.fasta  gene_candidates/B241_UL3Z3_aa.fasta gene_candidates/B201_UL3Z3_nt.fasta  gene_candidates/B241_UL3Z3_nt.fasta gene_candidates/B241_UL3selected_nt.fasta
		do
			fasta_formatter -i $file -o TEMP
			mv TEMP $file
			python alter_header.py $file
		done
}

function plot_images
{
	#Rscript plot_transcriptomics.R B201_U/B201_U_bsr_matrix.txt Up_B201.png B201 Up-Regulated
	#Rscript plot_transcriptomics.R B241_U/B241_U_bsr_matrix.txt Up_B241.png B241 Up-Regulated

	#Rscript plot_transcriptomics.R B201_D/B201_D_bsr_matrix.txt Down_B201.png B201 Down-Regulated
	#Rscript plot_transcriptomics.R B241_D/B241_D_bsr_matrix.txt Down_B241.png B241 Down-Regulated

	#Rscript plot_transcriptomics.R B241_U_misc/B241_U_misc_bsr_matrix.txt Up_B241_misc.png B241 Up-Regulated

	Rscript plot_transcriptomics.R B241_U_misc/B241_U_misc_bsr_matrix.txt TEMP.png B241 Up-Regulated
}

#alter_headers
plot_images
