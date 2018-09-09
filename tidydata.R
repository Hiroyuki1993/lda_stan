library(tidyverse)
library(tidytext)

corpus = read_csv("./corpus_20news.txt", col_names = "words")
corpus = corpus %>% mutate(doc = seq(1:nrow(corpus)))
corpus.tidy = corpus %>% unnest_tokens(word, words)
corpus.tidy = corpus.tidy %>% mutate(word = as.integer(word))

vocab = read_csv("./vocab_20news.txt", col_names = "word")

M = nrow(corpus)
N = nrow(corpus.tidy)
V = nrow(vocab)
K = 20

offset = matrix(nrow = M, ncol = 2)

last_ind = 0
for (m in 1:M) {
  n_words = as.integer(corpus.tidy %>% filter(doc == m) %>% count())
  offset[m,1] = last_ind + 1
  offset[m,2] = offset[m,1] + (n_words - 1)
  last_ind = offset[m,2]
}
save.image("./20news.RData")
