library(tm)
badwords <- read.csv("Data/badwords.csv")

getlastn <- function(s, n) 
{
    s <- tolower(s)
    s <- gsub("^[[:punct:][:space:][:cntrl:][:digit:]]+", "", s)
    s <- gsub("[[:space:]]+", " ", s)
    x <- unlist(strsplit(s, " "))
    m <- length(x)
    if (m < n) {
        s1 <- " "
        cat(paste(s, "is shorter than", n, "\n"))
    } else {
        s1 <- paste(x[(m-n+1):m], collapse=" ")
    }
    return(s1)
}

seq1 <- function(st, ed)
{
    if (st > ed) {
        return (NULL)
    }
    st:ed
}

rep1 <- function(s, n)
{
    if (n <= 0) {
        return (NULL)
    }
    rep(s,n)
}

cleanword <- function(input)
{
    input <- removeNumbers(input)#remove number
    input <- tolower(input)#to lower case
    input <- stripWhitespace(input)
    input <- gsub("^[[:punct:][:space:][:cntrl:][:digit:]]+", "", input)
    input <- gsub('[])(,;:#%$^*\\~{}[&+=@/"`|<>_]+', " ", input)
    return(input)
}    

seekngram<- function(input, ngram, k=3)
{
    first_letter <- substring(input, 1, 1)
    load(paste("./data/",ngram,"-gram_",first_letter, ".RData",sep=""))
    test <- get(paste(ngram,"-gram_",first_letter, sep=""))
    rm(list=paste(ngram,"-gram_",first_letter, sep=""))
    prediction <- test[grepl(test[,1], pattern=paste("^",input, " ", sep="")),1:2]
    
    if(length(prediction[,1])>0){
        wbw <- strsplit(as.matrix(prediction[,1]), split="\\s+")
        wbw <- matrix(unlist(wbw), ncol = ngram, byrow = TRUE)
        wbw <- data.frame(cbind(wbw, prediction[,2]))
        wbw <- matrix(unlist(wbw), ncol = ngram+1, byrow = F)
        wbw <- wbw[!grepl(wbw[,ngram], pattern = paste("^",badwords[,1],"$", collapse="|", sep="")),]
        wbw <- matrix(unlist(wbw), ncol = ngram+1, byrow = F)
        wbw <- wbw[order(as.numeric(wbw[,ngram+1]), decreasing = TRUE),]
        wbw <- matrix(unlist(wbw), ncol = ngram+1, byrow = F)
        k <- min(k, length(wbw[,1]))
        return(as.vector(wbw[1:k,ngram]))
    }
    return(NULL)
}

predictwords <- function(input, maxResults = 3) 
{
    k <- maxResults
    input <- cleanword(input)
    # input <- removeNumbers(input)#remove number
    # input <- tolower(input)#to lower case
    # input <- stripWhitespace(input)
    # input <- gsub("^[[:punct:][:space:][:cntrl:][:digit:]]+", "", input)
    # input <- gsub('[])(,;:#%$^*\\~{}[&+=@/"`|<>_]+', " ", input)
     

    if(input == ''|input == "na na") 
        stop ('Warning: Just input something') #figure out a more graceful way of exiting

    # k denotes no of return from the predict function
    # n denotes n-gram
    n <- min(5, 1+length(unlist(strsplit(input,' ') )));
    final <- NULL

    while ((k > 0) && (n > 1))
    {
        inputn <- getlastn(input, n-1)
        predstr <- seekngram(inputn, n, k)
        if (!is.null(predstr)) {
            predstr <- cbind(predstr, rep1(n,length(predstr)))
            final <- rbind(final, predstr)
            final <- matrix(final[!duplicated(final[,1]),], ncol=2)
         }
            
        if (length(final[,1]) < k) {
            n <- n-1 # backword to n-1 gram
        } else {
            k <- 0
        }
    }
    return(final)
}

