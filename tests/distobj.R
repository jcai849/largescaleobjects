source("init.R")

stopifnot(
	  identical(chunk(distObj1), list(chunk1, chunk2, chunk3)),
	  identical(from(distObj1), c(1L, 6L, 11L)),
	  identical(to(distObj1), c(5L, 10L, 15L)),
	  identical(size(distObj1), c(5L, 5L, 5L))
)
