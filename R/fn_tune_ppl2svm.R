##cross-validataion for Group coordinate descent : Sparse PALS GCD

tune_ppl2svm <- function(x, y, d, H, C, lambda.grid, gamma, penalty, max.iter, n.fold)
{
  n <- length(y)
  #p <- length(x)/n
  cat(n.fold, "-fold CV.\n", sep = "")
  L <- length(lambda.grid)
  value <- matrix(0, n.fold, L)
  
  for (ll in 1:L){
    for (jj in 1:n.fold){
      new.index <- sample(n)
      step <- round(n/n.fold)
      
      ts.id <- ((jj-1)*step+1):min(((jj)*step), n)
      tr.id <- unlist(setdiff(1:n, ts.id))
      
      #G.C.D.
      obj <- ppl2svm(x=x[tr.id,,drop = F], y=y[tr.id,drop = F], H=H, C=C, lambda=lambda.grid[ll], gamma, penalty, max.iter)$vectors[,1:d,drop = F]
      
      value[jj,ll] <- dcor(y[ts.id,drop = F], x[ts.id,,drop = F] %*% obj)$dcor
    }
  }
  tmp <- apply(value, 2, mean)
  names(tmp) <- lambda.grid
  
  sel <- which.max(tmp)
  
  list(opt.lambda = lambda.grid[sel], dcor = round(tmp,3))
}

