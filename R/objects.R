# gen_fun(n: integer) -> numeric[n], e.g. \(n){rnorm(n, 100, 10)}
d_matrix <- function(nrow=100, ncol=5, n_blocks=30, gen_fun=\(n){rnorm(n, 1E5, 1/5*1E5)}) {
  block_row_mins <- nrow %/% n_blocks
  block_rows <- rep(block_row_mins, n_blocks)
  extra_rows <- nrow %% n_blocks
  if (extra_rows) {
    block_rows[1:extra_rows] = block_rows[1:extra_rows] + 1
  }
  block_n <- ncol * block_rows
  f <- \(n, nrow, gen_fun) { matrix(gen_fun(n),nrow) }
  calls <- rep(list(f), n_blocks)
  args <- cbind(n=block_n, nrow=block_rows) |>
         apply(1, as.list) |>
         lapply(c, list(gen_fun=gen_fun))
  cs <- do.ccall(calls, args, balance=TRUE)
  d <- DistributedObject(cs)
  d <- materialise(d); dim(d) <- c(n_blocks, 1); d <- dematerialise(d)
  d
}
