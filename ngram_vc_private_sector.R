# Install
install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes

#Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("ggplot2")
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_211')
library("rJava")
library("RWeka")

#Read the text file
text <- readLines(file.choose()) #remember to copy to MS Word, then SAVE AS ".txt"!!!

# Load the data as a corpus
docs <- Corpus(VectorSource(text))

#Inspect
inspect(docs)

#Text transformation
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

#CLEANING
#Fix punctuation
docs <- tm_map(docs, content_transformer(function(x, pattern) gsub(x, pattern = "resilient", replacement = "resilience")))
# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# docs <- tm_map(docs, removeWords, stopwords("spanish"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("will")) 
docs <- tm_map(docs, removeWords, c("can", "also", "based", "well"))
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)

#Term matrix
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 100)
write.csv((as.matrix(dtm)), "test.csv")

#Word cloud
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

#Second filter
#docs <- tm_map(docs, content_transformer(function(x, pattern) gsub(x, pattern = "educativo", replacement = "educación")))
#docs <- tm_map(docs, content_transformer(function(x, pattern) gsub(x, pattern = ".", replacement = "")))
#docs <- tm_map(docs, removeSpecialChars(function(x, pattern) gsub(x, pattern = "[^a-zA-Z0-9 ]", replacement = "")))
docs <- tm_map(docs, removeWords, c("disaster", "risk", "resilience", "drr", "sendai", "framework"))

#PrivateSector
docs <- tm_map(docs, removeWords, c("new", "landslide", "icl", "disaster", "book", "papers", "books", "issn", "series"))
docs <- tm_map(docs, content_transformer(function(x, pattern) gsub(x, pattern = "pandemic", replacement = "covid")))
docs <- tm_map(docs, content_transformer(function(x, pattern) gsub(x, pattern = "markets", replacement = "market")))
docs <- tm_map(docs, content_transformer(function(x, pattern) gsub(x, pattern = "partnerships", replacement = "partners")))
docs <- tm_map(docs, content_transformer(function(x, pattern) gsub(x, pattern = "partnership", replacement = "partners")))
docs <- tm_map(docs, content_transformer(function(x, pattern) gsub(x, pattern = "easiermarket", replacement = "market")))
docs <- tm_map(docs, content_transformer(function(x, pattern) gsub(x, pattern = "costly", replacement = "cost")))
docs <- tm_map(docs, content_transformer(function(x, pattern) gsub(x, pattern = "costlier", replacement = "cost")))

#Term matrix
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 100)
write.csv((as.matrix(dtm)), "test.csv")

#Word cloud
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=40, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))