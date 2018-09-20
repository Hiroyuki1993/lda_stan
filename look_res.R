library(tidyverse)

res = rstan::extract(fit.vb)

phi = apply(res$phi, c(2,3), mean)

source("./rel_terms.R")
topics = rel_terms(phi, vocab.new, lambda = 1)
topics.df = data.frame(matrix(unlist(topics), nrow=10, byrow=F))
colnames(topics.df) = paste("topic", seq(20))
topics.df

top_n_words = function(i, n) {
  word_index = which(phi[i,] >= sort(phi[i,], decreasing = T)[n])
  vocab.new %>% filter(new_ind %in% word_index)
}

top_n_words(20,10)

