#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

#args <- "./Course11/Databackup/Oefen_Seq_GC.txt"

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "out.png"
}

GCfile <- read.table(args[1], header=TRUE)
  
dat <- read.table(text = paste(GCfile$Locus_tag[1], "\n", GCfile$GC.percentage[1], "\n", 100-GCfile$GC.percentage[1]), header=TRUE)
  
for(i in 2:length(rownames(GCfile))){
  dat[i] <- read.table(text = paste(GCfile$Locus_tag[i], "\n", GCfile$GC.percentage[i], "\n", 100-GCfile$GC.percentage[i]), header=TRUE)
}

file_name <- paste(args[2], sep="")
png(file_name)
barplot(as.matrix(dat), horiz = TRUE, col = c("red", "black"), legend.text = c("gc", "at"), las=1, cex.names = 0.5)

dev.off() 
