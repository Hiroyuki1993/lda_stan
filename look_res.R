library(tidyverse)

res = rstan::extract(fit.vb)

phi = apply(res$phi, c(2,3), mean)

top_n_words = function(i, n) {
  word_index = which(phi[i,] >= sort(phi[i,], decreasing = T)[n])
  vocab.new %>% filter(new_ind %in% word_index)
}

top_n_words(20,10)

rel_terms(phi, vocab.new, lambda = 1)
