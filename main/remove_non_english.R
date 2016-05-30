#creating a not-English words file
workingfolder <- "d:/Users/henry/Desktop/capstone/Data"
setwd(workingfolder)
library("stringi")


load("clean_data.RData")
token <- stri_extract_all_words(clean_data, locale = "en_US")
rm(clean_data)

#creating a TOKEN data frame
dic_data <- data.frame(table(matrix(unlist(token), ncol = 1, byrow = TRUE)))
rm(token)


#separating words with frequency used <= 35 times
dic_data_nw <- dic_data[dic_data$Freq <= 35,]

#loading the dictionary
words <- read.csv("words.csv", sep=";")

#couting how many times to work with the loop
y <- round(length(words[,1])/2500)+1

#loop for removing the real words from the TOKEN
for(n in 0:y){
    t = n*2500+1
    b = n + 1
    x = b*2500
    
    dic_data_nw <- dic_data_nw[!grepl(dic_data_nw[,1], pattern = paste("^",words[t:x,],"$", collapse="|",sep="")),]
    print(c("Round",b))
    print(c("Last x value",x))
    print(c("remaining not words",length(dic_data_nw[,1])))
    
}
save(dic_data_nw, file="dic_data_nw.RData")

#load("dic_data_nw.RData")
#removing the words with frequency lower than 2 since we wont keep n-gram with less than 2 times appearance.
dic_data_nw4 <- dic_data_nw[dic_data_nw$Freq > 2,]
not_words <- dic_data_nw4[,1]
save(not_words, file="not_words.RData")


###----- after n-graming phase, cleaning of non-English words.
workingfolder <- "d:/Users/henry/Desktop/capstone/Data"
# resultfolder <- paste(workingfolder, "/results", sep="")
setwd(workingfolder)
load("not_words.RData")
y <- round(length(not_words)/200)+1

#loop for removing the not words from the ngram
for(n in 2:5){
    if(n==2){
        cap = 2
    }
    else{
        cap = 1
    }

    for(l in letters){
        ngramL <- read.csv(paste(workingfolder, "/ngram", n,"_DF_", l , ".csv", sep=""), colClasses=c("NULL", NA, NA))
        ngramL <- ngramL[ngramL$Freq > cap,]
        ngramL$ngram <- paste(" ", ngramL$ngram, " ", sep= "")
        for(n2 in 0:y){
            t = n2*200+1
            b = n2 + 1
            x = b*200
            p1 <- proc.time()
            ngramL <- ngramL[!grepl(ngramL$ngram, pattern = paste(" ", not_words[t:x], " ", collapse="|", sep="")),]
            
            print(c("ngram number", n, "Letter", l))
            print(c("Round",b, "of", y))
            print(c("number of words passed",x))
            print(c("remaining real words",length(ngramL[,1])))
            print(c(proc.time() - p1))
            print("--------------------------------")
            
        }
        ngramL$ngram <- gsub("^[[:blank:]]+", "", ngramL$ngram)
        ngramL$ngram <- gsub("[[:blank:]]+$", "", ngramL$ngram)
        write.csv(ngramL, file = paste(workingfolder, "/ngram_clean_",n,"_DF_",l,".csv", sep=""))
        print("--------------------------------")
        print(c("saving file",n, "letter", l))
        print("--------------------------------")
        print("--------------------------------")
        rm(ngramL)
    }
    
}

rm(list=ls())
#transforming back to .RData since it they represent faster reads and lower hard drive space.

workingfolder <- "d:/Users/henry/Desktop/capstone/Data"
resultfolder <- paste(workingfolder, "/data", sep="")
setwd(workingfolder)
for(l in letters){
    for(n in 2:5){
        assign(paste(n,"-gram_",l,sep=""), read.csv(paste(resultfolder, "/ngram_clean_", n, "_DF_", l, ".csv", sep=""), colClasses=c("NULL",NA,NA)))
        save(list = paste(n,"-gram_",l,sep=""), file = paste(resultfolder, "/", n,"-gram_",l, ".RData",sep=""))
    }
}
