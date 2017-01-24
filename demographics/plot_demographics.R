#!/usr/bin/Rscript 
#!/usr/bin/env Rscript

options(warn=1)

#library(plyr)
library(ggplot2)
#library(reshape2)
#library(dplyr)
#require(RColorBrewer)
library(readr)
#library(data.table)
#library(gridExtra)

original.parameters=par()
options(width=9999)

file_name = commandArgs(trailingOnly=TRUE)[1]
image_name = commandArgs(trailingOnly=TRUE)[2]
image_name_2 = commandArgs(trailingOnly=TRUE)[3]

myDF <- read_delim(file_name, delim ='\t') 
myDF <- myDF[ which(myDF$Strain != 'B055'), ]

attach(myDF)

png(filename=image_name, width=3750,height=2750,res=300)
par(mar=c(9.5,4.3,4,2))
print(p <- ggplot(myDF, aes(Genome_Size, GC_Content)) + geom_point(stroke=2, size=5, alpha=0.5, aes(colour = factor(Strain), shape=factor(Flocculate))) + 
			labs(title='Genome Size vs. GC-content for E. coli O157:H7 Strains', x='Genome Size', y='GC-Content') +
			theme(axis.text.x=element_text(size=13), axis.text.y=element_text(size=13), plot.title = element_text(size=18)) +
			theme(text=element_text(size=14)) + guides(colour=guide_legend(title='Strain Names'), shape=guide_legend(title='Flocculate')) )


#x_legend_name = substitute(paste(italic('Campylobacter '), italic(species_text)))


png(filename=image_name_2, width=3750,height=2750,res=300)
par(mar=c(9.5,4.3,4,2))
print(g <- ggplot(myDF, aes(Strain, Feature_Count)) + geom_bar(stat = 'identity', aes(fill=Strain)) + 
#print(g <- ggplot(Strain, Feature_Count) + geom_bar(aes(fill=Strain)) + 
			#theme(axis.text.x=element_text(angle=45, size=14, hjust=1), axis.title.x=element_text(size=18), axis.text.y=element_text(size=14), axis.title.y=element_text(size=18), legend.position='none', plot.title = element_text(size=22)) + 
			theme(axis.text.x=element_text(angle=90), text=element_text(size=14)) + guides(fill=FALSE) + #(colour=guide_legend(title=NULL)) +
			labs(title='CDS Features per Strain (chromosome only)', x='Strain', y='Feature Count (CDS only)\n') )

dev.off()
