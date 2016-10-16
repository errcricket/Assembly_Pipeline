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
file_name_2 <- args[3]
image_name_2 <- args[4]

data <- read_delim(file_name, delim='\t')
names(data)[1] <- 'Gene'

m_data <- melt(data)
names(m_data)[2] <- 'Strain'
names(m_data)[3] <- 'LS_BSR'
write.table(m_data, 'temp.txt', sep = '\t', row.names = F, col.names = T, quote = F)

col_breaks = c(0, 0.5, 1)
my_palette <- colorRampPalette(wes_palette('Zissou', 21, type = 'continuous'))
# Zissou = c("#3B9AB2", "#78B7C5", "#EBCC2A", "#E1AF00", "#F21A00"),

png(filename=image_file, width=3750,height=2750,res=300)
print(i <- ggplot(m_data, aes(x=Gene, y=Strain)) +
        geom_tile(color='gray', aes(fill = LS_BSR)) +
        theme(axis.text.x=element_text(angle=90, hjust=1, size=5), axis.title.x=element_text(size=14))  +
        theme(axis.text.y=element_text(size=9), axis.title.y=element_text(size=14))  +
        labs(title='LS-BSR for Acid Resistant Genes (by reference genome)') +
        theme(plot.title = element_text(size=18)) +
        scale_fill_gradientn(colours = my_palette(300)) )
dev.off()

data_g <- read_delim(file_name_2, delim='\t')
names(data_g)[1] <- 'Gene'
        
m_data_g <- melt(data_g)
names(m_data_g)[2] <- 'Strain'
names(m_data_g)[3] <- 'LS_BSR'

png(filename=image_name_2, width=3750,height=2750,res=300)
print(i <- ggplot(m_data_g, aes(x=Gene, y=Strain)) +
        geom_tile(color='gray', aes(fill = LS_BSR)) +
        theme(axis.text.x=element_text(angle=90, hjust=1, size=7), axis.title.x=element_text(size=14))  +
        theme(axis.text.y=element_text(size=9), axis.title.y=element_text(size=14))  +
        labs(title='LS-BSR for Virulent Genes (by gene)') +
        theme(plot.title = element_text(size=18)) +
        scale_fill_gradientn(colours = my_palette(300)) )
dev.off()

