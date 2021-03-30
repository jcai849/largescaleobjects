# Instantiate

distObjStub <- function(x) {
	dos <- new.env(TRUE, emptyenv())
	class(dos) <- "distObjStub"
	chunkStub(dos) <- x
	dos
}

is.distObjStub <- function(x) inherits(x, "distObjStub")
is.distributed <- function(x) is.distObjStub(x) | is.chunkStub(x)

chunkStub.distObjStub <- function(x) get("chunk", x, inherit=F)

preview.distObjStub <- function(x, ...) lapply(chunkStub(x), preview)

print.distObjStub <- function(x, ...) {
	cat("Distributed Object Stub with", format(length(chunkStub(x))), 
	    "chunk stubs.\n")
#	cat(" Total size", format(sum(size(x))), "\n")
	cat("First chunk stub:\n")
	print(chunkStub(x)[[1]])
}

# User-level

Math.distObjStub <- function(x, ...) 
	do.call.distObjStub(.Generic, 
			   c(list(x=x), list(...)))

Ops.distObjStub <- function(e1, e2) 
	if (missing(e2)) {
		do.call.distObjStub(.Generic,
				   list(e1=e1)) 
	} else
		do.call.distObjStub(.Generic,
				   list(e1=e1, e2=e2))

Complex.distObjStub <- function(z) 
	do.call.distObjStub(.Generic,
			   list(z=z))

Summary.distObjStub <- function(..., na.rm = FALSE) {
	mapped <- unstub(do.call.distObjStub(.Generic,
					    c(list(...), list(na.rm=I(na.rm))),
					    store=FALSE))
	do.call(.Generic, 
		c(list(mapped), list(na.rm=na.rm)))
}

`$.distObjStub` <- function(x, name)
	do.call.distObjStub("$", list(x=x, name=I(name)))

table.distObjStub <- function(...)
	unstub(do.call.distObjStub("table",
				  list(...)))

dim.distObjStub <- function(x) {
	dims <- sapply(chunk(do.call.distObjStub("dim", list(x=x))), unstub)
	c(sum(dims[1,]), dims[,1][-1])
}
