source("init.R")

# recycling & auto-dispersion
stopifnot(
	  identical(1:3 + 1:5,
		    emerge(do.call.chunkRef("+",
					    list(x = 1:3,
						 y = chunk1),
					    target = chunk1))),
	  identical(1:3 + 1:15,
		    emerge(do.call.distObjRef("+", 
					      list(x = 1:3, 
						   y = distObj1))))
)

# AsIs non-dispersion

stopifnot(
	  identical(c(1:3, 1:2) + 1:15,
		    emerge(do.call.distObjRef("+", 
					      list(x = I(1:3), 
						   y = distObj1))))
)

clear()
