ids<-read.table("../Variants/IDS.txt",header=FALSE)

pcs<-read.table("pcs_LycGoff.txt")


q2<-read.table("q2_lyc_goff.txt",header=TRUE,sep=",")
barplot(rbind(q2$median[1:922],q2$median[923:1844]),beside=FALSE,horiz=FALSE,border=NA,col=c("orange","cadetblue"),names.arg=ids[,2],las=2)

mnq<-tapply(X=q2$median[1:922],INDEX=ids[,2],mean)
plot(pcs$PC1,mnq,xlab="PC1",ylab="Admixture proportion",pch=19)
## low = ids, high = melissa
cor.test(pcs$PC1,mnq)
#
#	Pearson's product-moment correlation
#
#data:  pcs$PC1 and mnq
#t = -32.575, df = 40, p-value < 2.2e-16
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
# -0.9901724 -0.9659333
#sample estimates:
#       cor
#-0.9816688

write.table(file="MnPopAdmixProp.txt",mnq,row.names=FALSE,col.names=FALSE)## use this for the model
