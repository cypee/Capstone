library("tm")
library("stringi")
library("gsubfn")
library("qdap")
library("beepr")
library("audio")
library("ngram")
workingfolder <- "d:/Users/henry/Desktop/capstone/Data"
setwd(workingfolder)


#ngram of 5


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
	ngram_list <- apply(clean_data1, 1, function(x) tryCatch({ngram(x , n =5)}, error=function(e){}))
	rm(clean_data1)
	ngram_sub <- rapply(ngram_list, function(x) as.matrix(get.ngrams(x)))
	rm(ngram_list)
	
	#removing leftover strange characters 
	ngram_sub <- gsub("^[-]+", "", ngram_sub)
	ngram_sub <- gsub("^[[:blank:]]+", "", ngram_sub)
	ngram_sub <- gsub("[[:blank:]]+", " ", ngram_sub)

	#Removing lines with less than 5 words
	ngram_sub <- ngram_sub[wc(ngram_sub)==5]
	save(ngram_sub, file=paste("ngram5_", n, ".RData", sep=""))
	cat(paste(paste("ngram4.",n,sep=""), "completed\n", sep=" "))
}

# load ngram data
for(n in 1:n_rep){
    load(paste("ngram5_", n,".RData", sep=""))
    assign(paste("ngram5_",n,sep=""), ngram_sub)
}

for(i in letters){
    for(n in 1:n_rep){
        test <- get(paste("ngram5_", n, sep=""))
        #if the file does not exist create the file
        if(!exists(paste("With5_",i,sep=""))){
            assign(paste("With5_",i,sep=""), test[grepl(test, pattern=paste("^[",i,"]", sep=""))])
        }
        #if the file already exists join them toguether
        else if(exists(paste("With5_",i,sep=""))){
             assign(paste("With5_",i,sep=""), c(get(paste("With5_",i,sep="")), test[grepl(test, pattern=paste("^[",i,"]", sep=""))]))
        }
    }
}

save(With5_a, file="With5_a.RData")
save(With5_b, file="With5_b.RData")
save(With5_c, file="With5_c.RData")
save(With5_d, file="With5_d.RData")
save(With5_e, file="With5_e.RData")
save(With5_f, file="With5_f.RData")
save(With5_g, file="With5_g.RData")
save(With5_h, file="With5_h.RData")
save(With5_i, file="With5_i.RData")
save(With5_j, file="With5_j.RData")
save(With5_k, file="With5_k.RData")
save(With5_l, file="With5_l.RData")
save(With5_m, file="With5_m.RData")
save(With5_n, file="With5_n.RData")
save(With5_o, file="With5_o.RData")
save(With5_p, file="With5_p.RData")
save(With5_q, file="With5_q.RData")
save(With5_r, file="With5_r.RData")
save(With5_s, file="With5_s.RData")
save(With5_t, file="With5_t.RData")
save(With5_u, file="With5_u.RData")
save(With5_v, file="With5_v.RData")
save(With5_w, file="With5_w.RData")
save(With5_x, file="With5_x.RData")
save(With5_y, file="With5_y.RData")
save(With5_z, file="With5_z.RData")


## Write results to .csv files
n <- 5
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
