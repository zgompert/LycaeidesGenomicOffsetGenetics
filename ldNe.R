## estimate Ne from LD between unlinked loci

## external libraries
library(data.table)

## functions--these are for Burrow's delta
## but I ended up using genotype correlations as well
## these give identical results as expected

## Burrow's delta, composite metric of LD
# n = total sample size
# n22 = number homozygous non-ref at both loci
# n21 = number homo non-ref locus A, het locus B
# n12 = number het locus A, homo non-ref locus B
# n11 = number het both loci
# pA = frequency of non-ref allele locus A
# pB = frequency of non-ref allele locus A
## from Weir 1996, also see Zaykin 2004, eqn 1
delta<-function(n=NA,n22=NA,n21=NA,n12=NA,n11=NA,pA=NA,pB=NA){
	d<-(1/n) * (2*n22 + n21 + n12 + 0.5 * n11) - (2 * pA * pB)
	## unbiased estimator, same as ldnd, see Waples and Do, 
	## 2008 doi: 10.1111/j.1755-0998.2007.02061.x
	d<-d*n/(n-1)
	return(d)
}

## Zaykin 2004 also shows that Corr(ga,gb) = delta/sqrt((pA * (1-P1) + DA)(pB * (1-pB) + DB)
## here DA and DB = PAA - pA^2 and pBB - pB^2, where PAA and PBB are hA and Hb below
## thus Corr(ga,gb), that is genotype correlation, is delta standardized as below, but not first squared

## empirically these seems to be about right...now exactly right!
## interestingly, Zaykin notes cov(ga,gb) = 2 delta, which I get exactly
## thus

## compute r^2 from delta, see equation in in Waples and Do 2008
## d = delta
## hA = frequency of non-ref homozygotes at locus A
## hB = frequency of non-ref homozygotes at locus B
## pA and pB as above
rd<-function(d=NA,hA=NA,hB=NA,pA=NA,pB=NA){
	rD<-d/(sqrt((pA * (1-pA) + (hA - pA^2))*(pB * (1-pB) +(hB - pB^2))))
	rD2<-rD^2 ## this makes more sense to me, get r first then square it
	return(rD2)
}

## read in the genotype data, convert to integer valued
G<-as.matrix(fread("g_lyc_goff.txt",sep=",",header=FALSE))
G<-round(G,0)
N<-922
L<-5000

snps<-read.table("subSnpIds.txt",header=FALSE)
ids<-read.table("../Variants/IDS.txt",header=FALSE)
chroms<-read.table("~/../gompert-group4/data/lycaeides/dovetail_melissa_genome/lgs.txt",header=TRUE)

## computing via delta and correlation, but going to use correlation
## 10,000 pairs each time, repeat this 100 times to get a resampling distribution
## Waples et al 2016, Estimating contemporary effective population size in non-model species using linkage disequilibrium across thousands of loci
## looks at the effect of including physically linked loci when going to genome scale,
## this can bias estimates, which is avoided with my approach here
pids<-unique(ids[,2])
J<-length(pids)

Ne<-matrix(NA,nrow=J,ncol=100)
NeD<-matrix(NA,nrow=J,ncol=100)
snpCnt<-rep(NA,J)

for(j in 1:J){
	cat("working on: ",pids[j],"\n")
	pop<-which(ids[,2]==pids[j])
	gsub<-G[pop,]
	N<-length(pop)
	p<-apply(gsub,2,mean)/2
	het<-apply(gsub==1,2,mean)
	## common variants on a chromosome, but not Z
	sids<-which(p > 0.1 & p < 0.9 & snps[,1] %in% chroms$NewScaf[1:23] & het < .5)
	snpCnt[j]<-length(sids)
	for(k in 1:100){
		rr<-rep(NA,10000)
		cr<-rep(NA,10000)
		for(i in 1:10000){
			ll<-sample(sids,2,replace=FALSE)
			while(snps[ll[1],1] == snps[ll[2],1]){ll<-sample(sids,2,replace=FALSE)}
			a<-ll[1]
			b<-ll[2]
			ga<-gsub[,a]
			gb<-gsub[,b]
			pa<-mean(ga)/2
			pb<-mean(gb)/2
			## computes LD from delta followed by standardization
			dd<-delta(n=N,n22=sum(ga==2 & gb==2),n21=sum(ga==2 & gb==1),
				  n12=sum(ga==1 & gb==2),n11=sum(ga==1 & gb==1),
				  pA=pa,pB=pb)
			rr[i]<-rd(d=dd,hA=mean(ga==2),hB=mean(gb==2),pA=pa,pB=pb)
			## computes LD pearson r^2 based on genotypes
			cr[i]<-((N/(N-1))^2 * cor(ga,gb)^2)
		}
		r2b<-mean(cr,na.rm=TRUE)
		r2bD<-mean(rr,na.rm=TRUE)
		## first step is to remove effect of sampling
		## specific corrections come from Waples 2006, 0.1007/s10592-005-9100-y
		## these differ for sample sizes less than vs greater than 30
		## the second step corrects for bias when estimating Ne from 
		if(N >= 30){
			r2res<-r2b- (1/N + 3.19/N^2)
			r2resD<-r2bD- (1/N + 3.19/N^2)
			if(r2res < 0){r2res<-0}## this results in Inf Ne, which matches Waples
			if(r2resD < 0){r2resD<-0}
			## from correlation
			if((1/9 -2.76 * r2res) > 0){
				Ne[j,k]<-(1/3 + sqrt(1/9 -2.76 * r2res))/(2*r2res)
			} else{
				Ne[j,k]<-(1/3 + 0)/(2*r2res) ## this matches Waples 2006
			}
			## drom delta
			if((1/9 -2.76 * r2resD) > 0){
				NeD[j,k]<-(1/3 + sqrt(1/9 -2.76 * r2resD))/(2*r2resD)
			} else{
				NeD[j,k]<-(1/3 + 0)/(2*r2resD)
			}
		} else{
			r2res<-r2b -(0.0018 + .907/N + 4.44/N^2)
			r2resD<-r2bD -(0.0018 + .907/N + 4.44/N^2)
			if(r2res < 0){r2res<-0}
			if(r2resD < 0){r2resD<-0}
			## from correlation
			if((.308^2 -2.08 * r2res) > 0){
				Ne[j,k]<-(.308 + sqrt(.308^2 -2.08 * r2res))/(2*r2res)
			}else{
				Ne[j,k]<-(.308 + 0)/(2*r2res)
			}
			## from delta
			if((.308^2 -2.08 * r2resD) > 0){
				NeD[j,k]<-(.308 + sqrt(.308^2 -2.08 * r2resD))/(2*r2resD)
			}else{
				NeD[j,k]<-(.308 + 0)/(2*r2resD)
			}
		}
	}
}
save(list=ls(),file="ne.rdat")

Ne[is.infinite(Ne)==TRUE]<-NA
NeD[is.infinite(NeD)==TRUE]<-NA

meds<-apply(Ne,1,median,na.rm=TRUE)
lb<-apply(Ne,1,quantile,probs=.25,na.rm=TRUE)
ub<-apply(Ne,1,quantile,probs=.75,na.rm=TRUE)

pdf("LdNeEstimates.pdf",width=5,height=9)
par(mar=c(4.5,4,1,1))
dotchart(meds,xlim=c(0,max(ub)*1.1),pch=20,cex.lab=1.3,labels=pids,xlab="Effective population size")
segments(lb,1:J,ub,1:J)
dev.off()

## time series Ne
tne<-read.table("TimeSeriesNe.txt",header=TRUE)
tkeep<-which(tne$set=="SAM_sub" & tne$pop %in% pids)
ldkeep<-which(pids %in% tne$pop)
## order matches
cbind(tne$pop[tkeep],pids[ldkeep])

## LD estimates are higher but highly correlated
pdf("NeComp.pdf",width=4.5,height=4.5)
par(mar=c(4.5,4.5,.5,.5))
o<-lm(tne$median[tkeep] ~ meds[ldkeep])
plot(meds[ldkeep],tne$median[tkeep],pch=19,xlab="LD-based Ne",ylab="Time series Ne",cex.lab=1.3)
abline(o$coefficients)
dev.off()
cor.test(meds[ldkeep],tne$median[tkeep])
#
#	Pearson's product-moment correlation
#
#data:  meds[ldkeep] and tne$median[tkeep]
#t = 5.0378, df = 5, p-value = 0.003974
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
# 0.5163799 0.9874228
#sample estimates:
#      cor 
#0.9140117 

out<-data.frame(pops=pids,median=meds,q25=lb,q75=ub)
write.table(out,file="ldNe.txt",col.names=TRUE,row.names=FALSE,quote=FALSE)
