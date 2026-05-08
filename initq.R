library(data.table)
g<-as.matrix(fread("pntest_lyc_goff.txt",header=FALSE))


## pca on the genotype covariance matrix
pcgcov<-prcomp(x=t(g),center=TRUE,scale=FALSE)

## kmeans and lda
library(MASS)
k2<-kmeans(pcgcov$x[,1:5],2,iter.max=10,nstart=10,algorithm="Hartigan-Wong")
k3<-kmeans(pcgcov$x[,1:5],3,iter.max=10,nstart=10,algorithm="Hartigan-Wong")

ldak2<-lda(x=pcgcov$x[,1:5],grouping=k2$cluster,CV=TRUE)
ldak3<-lda(x=pcgcov$x[,1:5],grouping=k3$cluster,CV=TRUE)

ldak2$posterior[is.nan(ldak2$posterior)]<-.5
ldak3$posterior[is.nan(ldak3$posterior)]<-.5

write.table(round(ldak2$posterior,5),file="ldak2.txt",quote=F,row.names=F,col.names=F)
write.table(round(ldak3$posterior,5),file="ldak3.txt",quote=F,row.names=F,col.names=F)

save(list=ls(),file="initq.rdat")

## when you run entropy use provide the input values as, e.g., -q ldak2.txt
## also set -s to something like 50
