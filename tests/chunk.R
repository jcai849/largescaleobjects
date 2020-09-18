source("init.R")

# Gets
stopifnot(

	  identical(from(chunk2), 6L),
	  identical(to(chunk2), 10L),
	  identical(size(chunk2), 5L),
	  identical(emerge(chunk2), 6:10)

)
