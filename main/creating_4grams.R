library("tm")
library("stringi")
library("gsubfn")
library("qdap")
library("beepr")
library("audio")
library("ngram")
workingfolder <- "d:/Users/henry/Desktop/capstone/Data"
setwd(workingfolder)


#ngram of 4

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
	ngram_list <- apply(clean_data1, 1, function(x) tryCatch({ngram(x , n =4)}, error=function(e){}))
	rm(clean_data1)
	ngram_sub <- rapply(ngram_list, function(x) as.matrix(get.ngrams(x)))
	rm(ngram_list)
	
	#removing leftover strange characters 
	ngram_sub <- gsub("^[-]+", "", ngram_sub)
	ngram_sub <- gsub("^[[:blank:]]+", "", ngram_sub)
	ngram_sub <- gsub("[[:blank:]]+", " ", ngram_sub)

	#Removing lines with less than 4 words
	ngram_sub <- ngram_sub[wc(ngram_sub)==4]
	save(ngram_sub, file=paste("ngram4_", n, ".RData", sep=""))
	cat(paste(paste("ngram4.",n,sep=""), "completed\n", sep=" "))
}

# load ngram data
for(n in 1:n_rep){
    load(paste("ngram4_", n,".RData", sep=""))
    assign(paste("ngram4_",n,sep=""), ngram_sub)
}

for(i in letters){
    for(n in 1:n_rep){
        test <- get(paste("ngram4_", n, sep=""))
        #if the file does not exist create the file
        if(!exists(paste("With4_",i,sep=""))){
            assign(paste("With4_",i,sep=""), test[grepl(test, pattern=paste("^[",i,"]", sep=""))])
        }
        #if the file already exists join them toguether
        else if(exists(paste("With4_",i,sep=""))){
             assign(paste("With4_",i,sep=""), c(get(paste("With4_",i,sep="")), test[grepl(test, pattern=paste("^[",i,"]", sep=""))]))
        }
    }
}

save(With4_a, file="With4_a.RData")
save(With4_b, file="With4_b.RData")
save(With4_c, file="With4_c.RData")
save(With4_d, file="With4_d.RData")
save(With4_e, file="With4_e.RData")
save(With4_f, file="With4_f.RData")
save(With4_g, file="With4_g.RData")
save(With4_h, file="With4_h.RData")
save(With4_i, file="With4_i.RData")
save(With4_j, file="With4_j.RData")
save(With4_k, file="With4_k.RData")
save(With4_l, file="With4_l.RData")
save(With4_m, file="With4_m.RData")
save(With4_n, file="With4_n.RData")
save(With4_o, file="With4_o.RData")
save(With4_p, file="With4_p.RData")
save(With4_q, file="With4_q.RData")
save(With4_r, file="With4_r.RData")
save(With4_s, file="With4_s.RData")
save(With4_t, file="With4_t.RData")
save(With4_u, file="With4_u.RData")
save(With4_v, file="With4_v.RData")
save(With4_w, file="With4_w.RData")
save(With4_x, file="With4_x.RData")
save(With4_y, file="With4_y.RData")
save(With4_z, file="With4_z.RData")


## Write results to .csv files
n <- 4
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
