library("tm")
library("stringi")
library("gsubfn")
library("qdap")
library("beepr")
library("audio")
library("ngram")
workingfolder <- "d:/Users/henry/Desktop/capstone/Data"
setwd(workingfolder)


#ngram of 2


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
	ngram_list <- apply(clean_data1, 1, function(x) tryCatch({ngram(x , n =2)}, error=function(e){}))
	rm(clean_data1)
	ngram_sub <- rapply(ngram_list, function(x) as.matrix(get.ngrams(x)))
	rm(ngram_list)
	
	#removing leftover strange characters 
	ngram_sub <- gsub("^[-]+", "", ngram_sub)
	ngram_sub <- gsub("^[[:blank:]]+", "", ngram_sub)
	ngram_sub <- gsub("[[:blank:]]+", " ", ngram_sub)

	#Removing lines with less than 2 words
	ngram_sub <- ngram_sub[wc(ngram_sub)==2]
	save(ngram_sub, file=paste("ngram2_", n, ".RData", sep=""))
	cat(paste(paste("ngram2.",n,sep=""), "completed\n", sep=" "))
}

# load ngram data
for(n in 1:n_rep){
    load(paste("ngram2_", n,".RData", sep=""))
    assign(paste("ngram2_",n,sep=""), ngram_sub)
}

for(i in letters){
    for(n in 1:n_rep){
        test <- get(paste("ngram2_", n, sep=""))
        #if the file does not exist create the file
        if(!exists(paste("With2_",i,sep=""))){
            assign(paste("With2_",i,sep=""), test[grepl(test, pattern=paste("^[",i,"]", sep=""))])
        }
        #if the file already exists join them toguether
        else if(exists(paste("With2_",i,sep=""))){
             assign(paste("With2_",i,sep=""), c(get(paste("With2_",i,sep="")), test[grepl(test, pattern=paste("^[",i,"]", sep=""))]))
        }
    }
}

save(With2_a, file="With2_a.RData")
save(With2_b, file="With2_b.RData")
save(With2_c, file="With2_c.RData")
save(With2_d, file="With2_d.RData")
save(With2_e, file="With2_e.RData")
save(With2_f, file="With2_f.RData")
save(With2_g, file="With2_g.RData")
save(With2_h, file="With2_h.RData")
save(With2_i, file="With2_i.RData")
save(With2_j, file="With2_j.RData")
save(With2_k, file="With2_k.RData")
save(With2_l, file="With2_l.RData")
save(With2_m, file="With2_m.RData")
save(With2_n, file="With2_n.RData")
save(With2_o, file="With2_o.RData")
save(With2_p, file="With2_p.RData")
save(With2_q, file="With2_q.RData")
save(With2_r, file="With2_r.RData")
save(With2_s, file="With2_s.RData")
save(With2_t, file="With2_t.RData")
save(With2_u, file="With2_u.RData")
save(With2_v, file="With2_v.RData")
save(With2_w, file="With2_w.RData")
save(With2_x, file="With2_x.RData")
save(With2_y, file="With2_y.RData")
save(With2_z, file="With2_z.RData")


## Write results to .csv files
n <- 2
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
