## read in all of the allele frequency data, write it to a single file, and do some simple 
## sanity check summaries
library(phangorn)
library(ape)

pf<-list.files(pattern="p_")
pf
# [1] "p_ABC.txt" "p_ABM.txt" "p_BCR.txt" "p_BHP.txt" "p_BIC.txt" "p_BNP.txt"
# [7] "p_BSD.txt" "p_BTB.txt" "p_CDY.txt" "p_CKV.txt" "p_DBQ.txt" "p_DCR.txt"
#[13] "p_GLA.txt" "p_GNP.txt" "p_GVL.txt" "p_HNV.txt" "p_KHL.txt" "p_LAN.txt"
#[19] "p_LCA.txt" "p_MON.txt" "p_MTU.txt" "p_OCY.txt" "p_PIN.txt" "p_PSP.txt"
#[25] "p_RDL.txt" "p_REW.txt" "p_RNV.txt" "p_SCC.txt" "p_SDC.txt" "p_SHC.txt"
#[31] "p_SLA.txt" "p_SUV.txt" "p_SV.txt"  "p_SYC.txt" "p_TBY.txt" "p_TIB.txt"
#[37] "p_TPT.txt" "p_UAL.txt" "p_VCP.txt" "p_VIC.txt" "p_WAL.txt" "p_YWP.txt"

pids<-gsub(pattern=".txt",replace="",x=gsub(pattern="p_",replace="",x=pf))

L<-142307
N<-length(pf)

P<-matrix(NA,nrow=L,ncol=N)
for(j in 1:N){
	pp<-read.table(pf[j],header=FALSE)
	P[,j]<-pp[,3]
}


fst<-function(p1=NA,p2=NA){
	pbar<-(p1+p2)/2
	Ht<-2*pbar*(1-pbar)
	Hs<-p1*(1-p1) + p2*(1-p2)
	ff<-mean(Ht-Hs)/mean(Ht)
	return(ff)
}

Fmat<-matrix(0,nrow=N,ncol=N)
for(j in 1:(N-1)){for(k in (j+1):N){
	Fmat[j,k]<-fst(P[,j],P[,k])
	Fmat[k,j]<-Fmat[j,k]
}}

rownames(Fmat)<-pids
colnames(Fmat)<-pids
tr<-upgma(as.dist(Fmat))
plot(tr)

pc<-prcomp(t(P),center=TRUE,scale=FALSE)
summary(pc)
#                           PC1     PC2     PC3     PC4     PC5     PC6     PC7
#Standard deviation     19.0569 13.1364 8.85357 7.35253 6.00824 5.76136 5.50022
#Proportion of Variance  0.3332  0.1583 0.07191 0.04959 0.03312 0.03045 0.02775
#Cumulative Proportion   0.3332  0.4914 0.56336 0.61295 0.64607 0.67652 0.70427
plot(pc$x[,1],pc$x[,2],type='n',xlab="PC1 (33.3%)",ylab="PC2 (15.8%)")
text(pc$x[,1],pc$x[,2],pids)


## write allele frquencies and PC scores

colnames(P)<-pids
write.table(file="P_LycGoff.txt",P,col.names=TRUE,row.names=FALSE,quote=FALSE)
pcs<-pc$x[,1:5]
rownames(pcs)<-pids
write.table(file="pcs_LycGoff.txt",pcs,col.names=TRUE,row.names=TRUE,quote=FALSE)
