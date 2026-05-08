d<-matrix(scan("depth_filter2x.txt",n=227692*922),nrow=227692,ncol=922,byrow=TRUE)
dsnp<-apply(d,1,mean)
dind<-apply(d,2,mean)

mn<-mean(dsnp)
bnd<-mn+3*sd(dsnp)

keep<-dsnp > 2 & dsnp < bnd

write.table(as.numeric(keep),file="keepCov.txt",row.names=FALSE,col.names=FALSE)
