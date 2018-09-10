library(tidyverse)
library(tidytext)

corpus = read_csv("./corpus_20news.txt", col_names = "words")
corpus = corpus %>% sample_n(1000)
corpus = corpus %>% mutate(doc = seq(1:nrow(corpus)))
corpus.tidy = corpus %>% unnest_tokens(word, words)
corpus.tidy = corpus.tidy %>% mutate(word = as.integer(word))

stop_words = corpus.tidy %>% count(word, sort=T) %>% filter(n > 1000 | n < 15)
corpus.tidy = corpus.tidy %>% anti_join(stop_words)

appeared_word = unique(corpus.tidy$word)

vocab = read_csv("./vocab_20news.txt", col_names = "word")
vocab = vocab %>% mutate(index = seq(nrow(vocab)))
vocab.new = vocab[appeared_word,]

vocab.new = vocab.new %>% mutate(new_ind = seq(nrow(vocab.new)))

corpus.lda = corpus.tidy %>% left_join(vocab.new, by = c("word" = "index"))

M = nrow(corpus)
N = nrow(corpus.lda)
V = nrow(vocab.new)
K = 20

offset = matrix(nrow = M, ncol = 2)

last_ind = 0
for (m in 1:M) {
  n_words = as.integer(corpus.lda %>% filter(doc == m) %>% count())
  offset[m,1] = last_ind + 1
  offset[m,2] = offset[m,1] + (n_words - 1)
  last_ind = offset[m,2]
}
save.image("./20news.RData")
