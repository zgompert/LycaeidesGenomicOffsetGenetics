p<-scan("af_lyc_goff.txt")
length(which(p > 0.05 & p < 0.95))
#[1] 30577
L<-length(p)
keep<-rep(0,L)
## sample 5000 at random
keep[sort(sample(which(p > 0.05 & p < 0.95),5000,replace=FALSE))]<-1
write.table(file="mafKeep.txt",keep,row.names=FALSE,col.names=FALSE)
