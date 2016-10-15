#!/usr/bin/Rscript 

options(warn=1)

library(ggplot2)
library(gplots)
library(readr)
library(reshape2)
library(RColorBrewer)
library(wesanderson)
library(colorRamps)
library(ggdendro)

original.parameters=par()
options(width=9999)

args = commandArgs(trailingOnly=TRUE)

file_name <- args[1]
image_file <- args[2]

#file_name <- 'AR_bsr_matrix.txt' #<- args[1]
#file_name <- 'AR_bsr_matrix_short.txt' #<- args[1]
data <- read_delim(file_name, delim='\t')
names(data)[1] <- 'Gene'

m_data <- melt(data)
names(m_data)[2] <- 'Strain'
names(m_data)[3] <- 'LS_BSR'
write.table(m_data, 'temp.txt', sep = '\t', row.names = F, col.names = T, quote = F)

col_breaks = c(0, 0.5, 1)
my_palette <- colorRampPalette(wes_palette('Zissou', 21, type = 'continuous'))
# Zissou = c("#3B9AB2", "#78B7C5", "#EBCC2A", "#E1AF00", "#F21A00"),

png(filename=image_file, width=3750,height=2750,res=300, pointsize=6)
#png(filename='Acid_Resistance_heatmap.png', width=3750,height=2750,res=300, pointsize=6)
print(i <- ggplot(m_data, aes(x=Gene, y=Strain)) +
		geom_tile(aes(fill = LS_BSR)) + 
		theme(axis.text.x=element_text(angle=90, hjust=1, size=5))  +
		scale_fill_gradientn(colours = my_palette(300)) )
dev.off()
