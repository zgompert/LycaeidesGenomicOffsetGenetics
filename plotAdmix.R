## plot admixture proportions for k=2
library(scales)

dat<-read.table("q2_lyc_goff.txt",header=TRUE,sep=",")
q<-dat[1:922,3:5]

ids<-read.table("../Variants/IDS.txt",header=FALSE)

popt<-tapply(X=1:922,INDEX=ids[,2],mean)
pmin<-tapply(X=1:922,INDEX=ids[,2],min)
pmax<-tapply(X=1:922,INDEX=ids[,2],max)
pp<-c(pmin,pmax[42])


pdf("sf_admix.pdf",width=9,heigh=4)
par(mar=c(4.5,4.5,.5,.5))
plot(q[,1],ylim=c(0,1),pch=19,axes=FALSE,ylab="Admixture proportion (q)",xlab="Individual",cex.lab=1.4)
N<-length(pmin)
for(i in seq(2,N,2)){
	polygon(c(pp[i],pp[i+1],pp[i+1],pp[i]),c(-.1,-.1,1.1,1.1),col=alpha("burlywood1",.3),border=NA)
}
points(q[,1],pch=19,col=alpha("black",.5))
segments(1:922,q[,2],1:922,q[,3])
axis(1,at=popt,unique(ids[,2]),las=2,cex.axis=.63)
axis(2,at=seq(0,1,.2))
box()
dev.off()
