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
library(rlist)

original.parameters=par()
options(width=9999)

args = commandArgs(trailingOnly=TRUE)

file_name <- args[1]
image_name <- args[2]
region <- args[3]

data <- read_delim(file_name, delim='\t')
names(data)[1] <- 'Gene'

m_data <- melt(data)
#head(m_data)
names(m_data)[2] <- 'Strain'
names(m_data)[3] <- 'LS_BSR'

#This section is to change to label color, but non-functional  to this point.
flocculation <- data.frame(Strain=c('B201', 'B0246', 'B250', 'B263', 'B266', 'B271', 'B307', 'B202', 'B204', 'B241', 'B244', 'B0245', 'B0247', 'B0249', 'B251', 'B264', 'B265', 'B269', 'B273', 'B296', 'B301', 'B306', 'B309', 'B311', 'B349', 'B055'), Flocculate=c('TRUE', 'TRUE', 'TRUE', 'TRUE', 'TRUE', 'TRUE', 'TRUE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE'))

m_data <- merge(m_data, flocculation, by='Strain')
m_data <- m_data[ which(m_data$Strain != 'B055'),]
names(m_data)

#change order according to flocculation
m_data$Strain <- factor(m_data$Strain, levels = c('B201', 'B0246', 'B250', 'B263', 'B266', 'B271', 'B307', 'B202', 'B204', 'B241', 'B244', 'B0245', 'B0247', 'B0249', 'B251', 'B264', 'B265', 'B269', 'B273', 'B296', 'B301', 'B306', 'B309', 'B311', 'B349'))

#write.table(m_data, 'temp.txt', sep = '\t', row.names = F, col.names = T, quote = F)

col_breaks = c(0, 0.5, 1)
my_palette <- colorRampPalette(wes_palette('Zissou', 21, type = 'continuous'))
title_name = paste('LS-BSR for Phage Region ', region, sep=' ')

png(filename=image_name, width=3750,height=2750,res=300)
print(i <- ggplot(m_data, aes(x=Gene, y=Strain)) +
		geom_tile(color='gray', aes(fill = LS_BSR)) + 
		theme(axis.text.x=element_text(angle=90, hjust=1, size=7), axis.title.x=element_text(size=14))  +
		theme(axis.text.y=element_text(size=9), axis.title.y=element_text(size=14))  +
		labs(title=title_name) + 
		theme(plot.title = element_text(size=18)) +
		scale_fill_gradientn(colours = my_palette(300)) )
dev.off()
