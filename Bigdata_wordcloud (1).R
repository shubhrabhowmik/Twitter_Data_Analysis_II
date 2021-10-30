# Get 1000 tweets to a search term - #bigdata
# Clean the tweets - lower cases, remove numbers, punctuations, stopwords
# Plot a wordcloud with 45 most frequent terms with min frequency 3
# Rotate 50% of the words
# Color your cloud

library("twitteR")
library("httr")
library("tm")

# all this info is obtained for the Twitter developer account
consumer_key = "ydK8pAFzVnu7107yqgEcL5GwS"
consumer_secret = "o7xPhcbEruDjN5GDsTJxRwZUAW4s4uDfPkWFmiKcr6GLQy4Lom"
access_token = "1039967328841039872-1owPPGUud9KIoCNIcM9aTc4kd6zszT"
access_secret = "QDQHU4LQMhAUJDqTkxbsbOJIVfGBCBu0LmNOU00G8a0Y9"

# we are using the setup_twitter_oauth fuction
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# Lets start with the Twitter scraping
bd_twittes = searchTwitter("#bigdata", n=1000)

class(bd_twittes)
length(bd_twittes)
head(bd_twittes)

bdlist = sapply(bd_twittes, function(x) x$getText())
bdCorpus = Corpus(VectorSource(bdlist))

bdCorpus = tm_map(bdCorpus, tolower) 
bdCorpus = tm_map(bdCorpus, removePunctuation)
bdCorpus = tm_map(bdCorpus, function(x) removeWords(x, stopwords()))
bdCorpus = tm_map(bdCorpus, PlainTextDocument)
bdCorpus = tm_map(bdCorpus, content_transformer(function(x) iconv(x, to='UTF-8', sub='byte')))

library("wordcloud")
install.packages("RColorBrewer")
library("RColorBrewer")
col = brewer.pal(5, "Dark2")
wordcloud(bdCorpus, min.freq = 3, scale = c(2,0.25),
          max.word = 100, random.order = F, random.color = T,
          rot.per=0.35, color = col)

