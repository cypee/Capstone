library(RWeka)
library(SnowballC)

library("tm")
library("stringi")
library("gsubfn")
library("qdap")
library("beepr")
library("ngram")
workingfolder <- "d:/Users/henry/Desktop/capstone/Data"
setwd(workingfolder)

twitter <- readLines(paste(workingfolder, "/final/en_US/en_US.twitter.txt", sep=""), encoding = "UTF-8", skipNul = TRUE)
blogs <- readLines(paste(workingfolder, "/final/en_US/en_US.blogs.txt", sep=""), encoding = "UTF-8", skipNul = TRUE)
news <- readLines(paste(workingfolder, "/final/en_US/en_US.news.txt", sep=""), encoding = "UTF-8", skipNul = TRUE)

# Convert UTF-8 to ASCII
twitter <- iconv(twitter, 'UTF-8', 'ASCII', "byte")
blogs <- iconv(blogs, 'UTF-8', 'ASCII', "byte")
news <- iconv(news, 'UTF-8', 'ASCII', "byte")
Encoding(twitter)  <- "UTF-8"#magic line to make the tolower function work

# Save them for faster loading
save(twitter, file="twitter.RData")
save(blogs, file="blogs.RData")
save(news, file="news.RData")

all <- c(news,blogs,twitter)
save(all, file="all.RData")
rm(list=ls())
load("all.RData")
# corpus <- Corpus(VectorSource(all[1:10000])) # Testing
corpus <- Corpus(VectorSource(all))
rm(all)
save(corpus, file="us_data_ori.RData")

load("us_data_ori.RData")
#convert to lower case
corpus <- tm_map(corpus, function(x) stri_trans_tolower(x[[1]]))
#make all lower letters - don't work with special characters (non ASCII)
#corpus <- tm_map(corpus, tolower)

#transform to english_US
corpus <- tm_map(corpus, function(x) stri_trans_general(x, "en_US"))
#transforming i in I again:
corpus <- tm_map(corpus, function(x) gsub(".i ", ". i ", x))
corpus <- tm_map(corpus, function(x) gsub(".i'", ". i'", x))

#remove punctuation with exception of . and '
corpus <- tm_map(corpus, function(x) gsub("[!?.]+", ".", x))
corpus <- tm_map(corpus, function(x) gsub('[])(,;:#%$^*\\~{}[&+=@/"`|<>_]+', " ", x))
#remove ponctuation not gonna use this code because it removes . and '
#corpus <- tm_map(corpus, removePunctuation)

#remove white spaces
corpus <- tm_map(corpus, stripWhitespace)
#remove numbers
corpus <- tm_map(corpus, removeNumbers)
#remove dot spaces for later split.
corpus <- tm_map(corpus, function(x) gsub(" \\.", ".", x))
corpus <- tm_map(corpus, function(x) gsub("\\. ", ".", x))
#splitting by dots
corpus <- tm_map(corpus, function(x) strsplit(x, "\\."))

#how to extrat words from a language
#corpus <- tm_map(corpus, function(x) stri_extract_words(x[[1]], locale = "en"))


#save for later use
save(corpus, file="us_data.RData")
rm(list=ls())


load("us_data.RData")
#convert to matrix with 1 column only
data_table <- matrix(unlist(corpus$content), ncol = 1, byrow = TRUE)
rm(corpus)
#remove lines that has less than 3 words
clean_data <- matrix(data_table[wc(data_table)>=3])
rm(data_table)
#save for later use
save(clean_data, file="clean_data.RData")

load("clean_data.RData")

clean_data <- iconv(clean_data, "UTF-8", "UTF-8")
#transforming single double quotes to apostrophe
clean_data <- gsub("[\u2018\u2019\u201A\u201B\u2032\u2035\u0092\u009d\u0096\u0093\u0094\u0099\u0091]", "'", clean_data)
clean_data <- gsub("[\031] ", "'", clean_data)

#removing double quotes and curly double quotes
clean_data <- gsub('[\u201C\u201D\u201E\u201F\u2033\u2036]', '', clean_data)

#removing strange stuffs
clean_data <- gsub("[¤º-»«Ã¢â¬Å¥¡Â¿°£·©Ë¦¼¹¸±???ð\u201C\u201D\u201E\u201F\u2033\u2036\u0097\u0083\u0082\u0080\u0081\u0090\u0095\u009f\u0098\u008d\u008b\u0089\u0087\u008a?????????.]+", " ", clean_data)
clean_data <- gsub("[\002\020\023\177\003]", "", clean_data)

#removing excessive lines
clean_data <- gsub(" [-]+ ", " ", clean_data)
clean_data <- gsub(" [-]+", " ", clean_data)
clean_data <- gsub("^[-]+", "", clean_data)
clean_data <- gsub("[-]+ ", " ", clean_data)
clean_data <- gsub("[-]+", "-", clean_data)


#fixing "i'm"s
clean_data <- gsub(" i' m ", " i'm ", clean_data)
clean_data <- gsub("^i' m ", "i'm ", clean_data)
clean_data <- gsub(" im ", " i'm ", clean_data)

#removign excessive apostrophes
clean_data <- gsub(" '+ ", " ", clean_data)
clean_data <- gsub(" '+", " ", clean_data)
clean_data <- gsub("'+ ", " ", clean_data)
clean_data <- gsub("^'+", "", clean_data)
clean_data <- gsub("'+$", "", clean_data)

#removing excessive blank spaces
clean_data <- gsub("^[[:blank:]]+", "", clean_data)
clean_data <- gsub("[[:blank:]]+", " ", clean_data)
clean_data <- gsub("[[:blank:]]+$", "", clean_data)

clean_data <- clean_data[wc(clean_data)>=3]

#save for later use
save(clean_data, file="clean_data.RData")


