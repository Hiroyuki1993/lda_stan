rel_terms = function(phi, vocab, lambda=0, n_terms=10) {
  K = nrow(phi)
  if (any(phi == 0)) { phi <- phi + .Machine$double.xmin }
  lift = log(phi) - log(colSums(phi)/K)
  rel = lambda*log(phi) + (1-lambda)*lift
  terms_list = list()
  for (k in 1:K) {
    indices = order(rel[k,], decreasing = T)[1:n_terms]
    rel_terms = vocab %>% filter(new_ind %in% indices) %>% select(word)
    terms_list[[paste("Topic", k)]] = rel_terms
  }
  terms_list
}
