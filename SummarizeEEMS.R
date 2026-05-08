library("rEEMSplots")
library("rgdal")
library("rworldmap")
library("rworldxtra")

dr<-list.dirs(path="./",recursive=FALSE)
fd<-dr[grep(pattern="eems-",x=dr)]

for(i in 1:length(fd)){
	oo<-gsub(x=fd[i],pattern=".//eems",replacement="o_eems")
	eems.plots(mcmcpath=fd[i],plotpath=oo,longlat=FALSE,add.grid=TRUE,add.demes=TRUE,add.outline=TRUE,out.png=FALSE,projection.in="+proj=longlat +datum=WGS84",projection.out="+proj=merc +datum=WGS84")
}

## do the same thing with xyq.values to get diversity
#head(xyq.values)

dimS<-read.table("IDsCoords.txt",header=FALSE)
Np<-dim(dimS)[1]
m<-matrix(NA,nrow=Np,ncol=6)## just using 400 and 500 grid, 600 bins things in a weird way
q<-matrix(NA,nrow=Np,ncol=6)## just using 400 and 500 grid, 600 bins things in a weird way
rf<-list.files(pattern="RData")
for(i in 1:6){
    load(rf[i])
    for(k in 1:Np){
    	a<-which.min(abs(dimS[k,3]-xym.values[,1])+abs(dimS[k,2]-xym.values[,2]))
        m[k,i]<-xym.values[a,3]
        q[k,i]<-xyq.values[a,3]
    }
}
row.names(m)<-dimS[,1]
row.names(q)<-dimS[,1]
    
write.table(m,file="effMigTab.txt",row.names=T,col.names=T,quote=FALSE)
write.table(q,file="effDivTab.txt",row.names=T,col.names=T,quote=FALSE)
