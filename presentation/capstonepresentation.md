Data Science Capstone Project Presentation
========================================================
author: Chih Yang Pee
date: 29/5/2016
autosize: true

Executive Summary
========================================================
- This capstone project aims to develop an application that predict the next word inputted by user.

- The <a href="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"> Capstone dataset </a> consists of three text files obtained from three different sources i.e. blogs, news and twitter. 

- The data is cleaned and then tokenize into n-grams which are then used to create the predictive algorithm.

- Finally a Shiny application that deployed the predictive algorithm has been successfully developed.



Data Cleaning and Tokenize the Corpus
========================================================
- In the process of data cleaning and tokenize n-grams, we follow the method proposed by <a href="https://github.com/rodrigodealexandre/DS-Courses/tree/master/Capstone">Rodrigo Bertollo de Alexandre (2014) </a> 

- The data is cleaned by converting all letters to lowercase, and removing all numbers,  non-ASCII symbols etc. The sentences ended by punctuations ". ? !" are eventually splitted as new sentences.

- The clean-up data is then used to create n-grams. As the <a href="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"> Capstone dataset </a> is quite large, we process it in batch to avoid the system running out of memory. 

Data Cleaning and Tokenize the Corpus (Cont.)
========================================================

- We created bigrams, trigrams, fourgrams and fivegrams. The non-English words are then removed from the n-grams.

- Finally each n-grams  is being partitioned and stored separately into 26 distinct files according to letters "a" to "z".

- In process of next word prediction, only the files required  will be loaded into memory. This significantly reduce the memory consumption and enhance the computational efficiency of the prediction algorithms.

Prediction Algorithm
========================================================
The prediction algorithm has two parameters the input string (denoted as "s") and number of return (denoted as "k").

1. Suppose s has m words, then prediction will search from n-gram database where n = min(5, m+1).

2. If found at least k matches the function will return k matches with highest term frequencies and stop.

3. Otherwise decrease the n by 1 and continue to search from database with lower-grams for k-matches. 

4. If the cumulative matches are at least k, the function will return top k matches and stop. Otherwise repeat step 3 and 4 until n <=1 and return all the matches and stop.



Shiny App and Related Links
========================================================

![The shiny App](shiny.png)
Enter your sentence, choose no of return and then press the submit button.
*** 

The app is hosted on <a href="https://cypee.shinyapps.io/shiny/"> ShinyApps.io </a>

The R Presentation is available at  <a href="http://rpubs.com/cypee/184859">my RPubs </a>.
.

Source code for ui.R and server.R files, the word prediction app and others are available in my <a href="https://github.com/cypee/Capstone"> GitHub repository </a>.

The interim milestone report is <a href="http://rpubs.com/cypee/177368"> available here </a>
