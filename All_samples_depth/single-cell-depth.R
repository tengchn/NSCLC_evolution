## -----------------------------------------------------------
# Script Title: Single cells depth plot
# Author: Teng Li
# Date: 2023-10-09
# Email: Teng.Li@auckland.ac.nz
## -----------------------------------------------------------

library(tools)
library(RColorBrewer)
library(dplyr)
library(stringr)
setwd("~/Singlecell/") ##change this to your own path

zipF<- "all_sample_depth.zip"
unzip(zipF)
files <- list.files("all_sample_depth",pattern="all.txt$",full.names = T)
duplicate_ratio<-read.table("all_duplicate_ratio.txt")
duplicate_ratio[,1]<-str_remove(duplicate_ratio[,1],".markdup.realigned.bam")
patient_names<-substr(basename(files),1,5) %>% unique()
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
patients<-list()
for (j in 1:length(patient_names)) {
  patients[[j]]<-files[grep(patient_names[j],files)]
  cov <- list()
  cov_cumul <- list()
  for (i in 1:length(patients[[j]])) {
    cov[[i]] <- read.table(patients[[j]][i])
    cov_cumul[[i]] <- 1-cumsum(cov[[i]][,5])
  }
  samples<-str_remove(basename(patients[[j]]),".markdup.realigned.bam.hist.all.txt")
  ##show the info of the total mapped reads and duplication ratio
  labs<-paste0(duplicate_ratio[match(samples,duplicate_ratio[,1]),][,1],"_",round(duplicate_ratio[match(samples,duplicate_ratio[,1]),][,3]/1e6,1),"M_",duplicate_ratio[match(samples,duplicate_ratio[,1]),][,4])
  cols<-colorRampPalette(col_vector)(length(cov))
  # Save the graph to a file
  pdf(paste0(patient_names[j],"_exome-coverage-plots.pdf"), height=10, width = 12)
  
  # Create plot area, but do not plot anything. Add gridlines and axis labels.
  plot(cov[[1]][2:401, 2], cov_cumul[[1]][1:400], type='n', xlab="Depth", ylab=expression("Fraction of capture target bases ">= "depth"), ylim=c(0,1.0), main=paste0(patient_names[j]))
  abline(v = 10, col = "gray60")
  abline(v = 20, col = "gray60")
  abline(v = 50, col = "gray60")
  abline(v = 100, col = "gray60")
  abline(h = 0.10, col = "gray60")
  abline(h = 0.20, col = "gray60")
  abline(h = 0.50, col = "gray60")
  abline(h = 0.90, col = "gray60")
  axis(1, at=c(10,20,50), labels=c(10,20,50))
  axis(2, at=c(0.90), labels=c(0.90))
  axis(2, at=c(0.50), labels=c(0.50))
  axis(2, at=c(0.10), labels=c(0.10))
  # Actually plot the data for each of the alignments (stored in the lists).
  for (i in 1:length(cov)) points(cov[[i]][2:401, 2], cov_cumul[[i]][1:400], type='l', lwd=3, col=cols[i])
  # Add a legend using the nice sample labeles rather than the full filenames.
  legend("topright", legend=labs, col=cols, lty=1, lwd=4, cex=0.5)
  dev.off()
}

##Get the potential remove list for each patients, then go back to check the previous plot to see if the delete is reasonable.
check<-list()
for (j in 1:length(patient_names)) {
  #assign(paste0(patient_names[j]), files[grep(patient_names[j],files)])
  patients[[j]]<-files[grep(patient_names[j],files)]
  cov <- list()
  cov_cumul <- list()
  first10<-list()
  for (i in 1:length(patients[[j]])) {
    cov[[i]] <- read.table(patients[[j]][i])
    cov_cumul[[i]] <- 1-cumsum(cov[[i]][,5])
    k<-patients[[j]][i] %>% basename() %>% str_split_i("\\.",1)
    first10[[k]]<-cov_cumul[[i]][1:10]
    # if (cov_cumul[[i]][20] < 0.1 || is.na(cov_cumul[[i]][10])) {
    #   check[[i]]<-cov_cumul[[i]][1:10]
    #   cat(patients[[j]][i],"\n")
    # }
  }
check[[patient_names[j]]]<-names(first10)[map_lgl(first10, function(cutoff){any(cutoff<0.15)})]
}  
check
