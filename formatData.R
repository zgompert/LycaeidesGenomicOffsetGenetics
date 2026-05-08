## libraries
library(data.table)
library(scales)
## create genotype distance matrix, based on ibs
## 5000 SNPs
G<-as.matrix(fread("g_lyc_goff.txt",sep=",",header=FALSE))
N<-922 ## rows
L<-5000 ## columns

snps<-read.table("subSnpIds.txt",header=FALSE)
ids<-read.table("../Variants/IDS.txt",header=FALSE)

## sanity check, pca, looks good
plot(o$x[,1],o$x[,2],pch=19,col=alpha("gray",.4))
pc1<-tapply(X=o$x[,1],INDEX=ids[,2],mean)
pc2<-tapply(X=o$x[,2],INDEX=ids[,2],mean)
text(pc1,pc2,unique(ids[,2]))

gd<-matrix(0,nrow=N,ncol=N)

## dist matrix
for(j in 1:(N-1)){for(k in (j+1):N){
	gd[j,k]<-mean(abs(G[j,]-G[k,]))/2
	gd[k,j]<-gd[j,k]
	}}
write.table(file="eems.diffs",gd,quote=FALSE,row.names=FALSE,col.names=FALSE)

## connect ids with coordinates--here
lldat<-read.table("IDsCoords.txt",header=FALSE)
idlatlon<-matrix(NA,nrow=N,ncol=2)
for(i in 1:N){
	p<-which(as.character(lldat[,1])==as.character(ids[i,2]))
	idlatlon[i,]<-as.numeric(lldat[p,2:3])
}
write.table(file="eems.coord",idlatlon,quote=FALSE,row.names=FALSE,col.names=FALSE)

