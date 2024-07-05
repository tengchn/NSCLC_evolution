library(ape)
library(apTreeshape)
library(phangorn)
library(tidyverse)
library(CollessLike)
setwd("~/Desktop/Singlecell/random_10/fix_seed/")##change this to your own path
files<-dir(full.names=TRUE) 
cellphy_results<-files[grep("bestTree",files)]

##Fuction for scaled sackin index
most_balance_sackin<-function(ntip){
  rr<-floor(log(ntip)/log(2))
  return(rr*ntip+2*(ntip-2^rr))
}

most_inbalance_sackin<-function(ntip){
  return((ntip+1)*ntip/2-1)
}

##make a data frame to record the results
result <- data.frame(matrix(ncol=6,nrow=length(cellphy_results)))
colnames(result)<-c("Patient","ratio", "colless", "cophen", "scaled-sackin", "mean_EI")

##Plot phylogeny and get related tree statistics
for (i in cellphy_results){
  index<-which(cellphy_results==i)
  name<-regmatches(basename(i), gregexpr("[[:digit:]]+", basename(i))) %>% unlist() %>% paste(sep="",collapse = "_")
  pdf(file=paste0("plot_cellphy_", substr(name,1,5), ".pdf"))
  t1<-read.tree(i)
  t1$tip.label<-t1$tip.label%>%str_remove_all("_001.markdup.realigned.bam")
  #t1$node.label<-(t1$node.label %>% as.numeric()%>%round(2))*100
  #t1$node.label[t1$node.label<50]<-""##not show lower than 50
  t1<-root(t1, outgroup=t1$tip.label[grep("N",t1$tip.label)],resolve.root = TRUE)##use normal sample as the outgroup
  t1<-drop.tip(t1,t1$tip.label[grep("N",t1$tip.label)])## remove outgroup
  plot.phylo(ladderize(t1,right = T),use.edge.length = T,cex=0.6,show.node.label = T)
  add.scale.bar(x=0.01,y=0.9,cex=0.7,lcol="blue",length = 0.1)

  internal_bl<-t1$edge.length[t1$edge[,2] > Ntip(t1)]
  terminal_bl<-t1$edge.length[t1$edge[,2] <= Ntip(t1)]
  ie_ratio<-sum(terminal_bl)/sum(internal_bl)
  mean_ei<-mean(terminal_bl)/mean(internal_bl)
  Colless<-balance.indices(t1,binary.Colless=T)[1]/((Ntip(t1)-1)*(Ntip(t1)-2)*0.5)
  Cophen<-cophen.index(t1,norm=T)
  scaled.sackin<-(sackin.index(t1)-most_balance_sackin(Ntip(t1)))/(most_inbalance_sackin(Ntip(t1))-most_balance_sackin(Ntip(t1)))
  result[index,]<-c(name,ie_ratio,Colless,Cophen,scaled.sackin,mean_ei)
  dev.off()
}

Patients_stage<-read.csv("Patients_Stage_random_10.csv", header= T) %>% mutate(across(Patient, ~ as.character(.x)))
##merge the result with the Patients info
results <- result %>% mutate_at(vars(-Patient), ~ round(as.numeric(as.character(.x)),5)) %>% 
  mutate(Sample=Patient) %>% mutate(across(Patient, ~ substr(.x,1,5))) %>% 
  left_join(., select(Patients_stage,Patient,stage,type,status,Random_sampled_cells)) %>% 
  mutate(cells=paste0(Patient," (",Random_sampled_cells," cells)")) %>% select(-Random_sampled_cells)
write.csv(results, file="cellphy_results.txt", row.names=FALSE) ##write the records file

##plot the tree statistics figure
for (i in colnames(results)[3:5]){
  temp_plot = ggplot(results, aes(x = ratio, y = results[,i],color=stage)) +
              geom_point(size=5) +
              geom_text(aes(x = ratio,label = cells),hjust=0.5, vjust=-1.5,size=3)+
              xlab("External/Internal branch length")+
              ylab(i)+
              scale_y_continuous()+
              scale_x_continuous()+
              ggtitle("Tree statistics")
  ggsave(temp_plot, file=paste0("Plot_EI_", i,".pdf"), device = "pdf",width = 10,height = 6)
}
