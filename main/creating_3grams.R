library("tm")
library("stringi")
library("gsubfn")
library("qdap")
library("beepr")
library("audio")
library("ngram")
workingfolder <- "d:/Users/henry/Desktop/capstone/Data"
setwd(workingfolder)


#ngram of 3


load("clean_data.RData")
data_sz <- length(clean_data)
block <- 1000000
# block <- 5000 # testing
n_rep <- ceiling(data_sz/block)
for (n in 1:n_rep) {
	load("clean_data.RData")
	if (n < n_rep) {
		clean_data1 <- matrix(clean_data[((n-1)*block):(n*block)])
	} else {
		clean_data1 <- matrix(clean_data[((n-1)*block):data_sz])
	}		
	rm(clean_data)
	ngram_list <- apply(clean_data1, 1, function(x) tryCatch({ngram(x , n =3)}, error=function(e){}))
	rm(clean_data1)
	ngram_sub <- rapply(ngram_list, function(x) as.matrix(get.ngrams(x)))
	rm(ngram_list)
	
	#removing leftover strange characters 
	ngram_sub <- gsub("^[-]+", "", ngram_sub)
	ngram_sub <- gsub("^[[:blank:]]+", "", ngram_sub)
	ngram_sub <- gsub("[[:blank:]]+", " ", ngram_sub)

	#Removing lines with less than 3 words
	ngram_sub <- ngram_sub[wc(ngram_sub)==3]
	save(ngram_sub, file=paste("ngram3_", n, ".RData", sep=""))
	cat(paste(paste("ngram3.",n,sep=""), "completed\n", sep=" "))
}

# load ngram data
for(n in 1:n_rep){
    load(paste("ngram3_", n,".RData", sep=""))
    assign(paste("ngram3_",n,sep=""), ngram_sub)
}

for(i in letters){
    for(n in 1:n_rep){
        test <- get(paste("ngram3_", n, sep=""))
        #if the file does not exist create the file
        if(!exists(paste("With3_",i,sep=""))){
            assign(paste("With3_",i,sep=""), test[grepl(test, pattern=paste("^[",i,"]", sep=""))])
        }
        #if the file already exists join them toguether
        else if(exists(paste("With3_",i,sep=""))){
             assign(paste("With3_",i,sep=""), c(get(paste("With3_",i,sep="")), test[grepl(test, pattern=paste("^[",i,"]", sep=""))]))
        }
    }
}

save(With3_a, file="With3_a.RData")
save(With3_b, file="With3_b.RData")
save(With3_c, file="With3_c.RData")
save(With3_d, file="With3_d.RData")
save(With3_e, file="With3_e.RData")
save(With3_f, file="With3_f.RData")
save(With3_g, file="With3_g.RData")
save(With3_h, file="With3_h.RData")
save(With3_i, file="With3_i.RData")
save(With3_j, file="With3_j.RData")
save(With3_k, file="With3_k.RData")
save(With3_l, file="With3_l.RData")
save(With3_m, file="With3_m.RData")
save(With3_n, file="With3_n.RData")
save(With3_o, file="With3_o.RData")
save(With3_p, file="With3_p.RData")
save(With3_q, file="With3_q.RData")
save(With3_r, file="With3_r.RData")
save(With3_s, file="With3_s.RData")
save(With3_t, file="With3_t.RData")
save(With3_u, file="With3_u.RData")
save(With3_v, file="With3_v.RData")
save(With3_w, file="With3_w.RData")
save(With3_x, file="With3_x.RData")
save(With3_y, file="With3_y.RData")
save(With3_z, file="With3_z.RData")


## Write results to .csv files
n <- 3
for(l in letters){
    load(paste("With",n,"_",l,".RData", sep=""))
    ngram <- get(paste("With",n,"_",l, sep=""))
    ngram <- data.frame(table(ngram))
    ngram <- ngram[character_count(ngram$ngram) > n,]
    write.csv(ngram, file = paste("ngram",n,"_DF_",l,".csv", sep=""))
    rm(ngram)
    rm(list = paste("With",n,"_",l, sep=""))
    print(paste("ngram:",n, ", letter:", l, sep=" "))
}
