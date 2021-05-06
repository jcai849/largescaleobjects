# Instantiate

distObjRef <- function(x) {
	stopifnot(all(sapply(x, is.chunkRef)))
	dos <- new.env(TRUE, emptyenv())
	class(dos) <- "distObjRef"
	chunkRef(dos) <- x
	dos
}

is.distObjRef <- function(x) inherits(x, "distObjRef")
is.distributed <- function(x) is.distObjRef(x) | is.chunkRef(x)

chunkRef.distObjRef <- function(x, ...) get("chunk", x, inherits=FALSE)

preview.distObjRef <- function(x, ...) lapply(chunkRef(x), preview)

print.distObjRef <- function(x, ...) {
	cat("Distributed Object Reference with", format(length(chunkRef(x))), 
	    "chunk references\n")
#	cat(" Total size", format(sum(size(x))), "\n")
	cat("First chunk reference:\n")
	print(chunkRef(x)[[1]])
}

# User-level

Math.distObjRef <- function(x, ...) 
	do.dcall(.Generic, 
			   c(list(x=x), list(...)))

Ops.distObjRef <- function(e1, e2) 
	if (missing(e2)) {
		do.dcall(.Generic,
				   list(e1=e1)) 
	} else
		do.dcall(.Generic,
				   list(e1=e1, e2=e2))

Complex.distObjRef <- function(z) 
	do.dcall(.Generic,
			   list(z=z))

Summary.distObjRef <- function(..., na.rm = FALSE) {
	mapped <- emerge(do.dcall(.Generic,
				  c(list(...),
				    list(na.rm=I(na.rm)))))
	do.call(.Generic, 
		c(list(mapped), list(na.rm=na.rm)))
}

`$.distObjRef` <- function(x, name)
	do.dcall("$", list(x=x, name=I(name)))

table.distObjRef <- function(...)
	emerge(do.dcall("table",
				  list(...)))

subset.distObjRef <- function(x, subset, ...)
	do.dcall("subset", c(list(x=x, subset=subset), list(...)))

dim.distObjRef <- function(x) {
	dims <- sapply(chunkRef(do.dcall("dim", list(x=x))), emerge)
	c(sum(dims[1,]), dims[,1][-1])
}

length.distObjRef <- function(x) sum(size(x))
nrow.distObjRef <- function(x) sum(size(x))
ncol.distObjRef <- function(x) ncol(chunkRef(x)[[1]])
colnames.distObjRef <- function(x, ...) colnames(chunkRef(x)[[1]])
cbind.distObjRef <- function(..., deparse.level = 1) do.dcall("cbind", list(...))
rbind.distObjRef <- function(...) combine(...)
c.distObjRef <- function(...) combine(...)
combine.distObjRef <- function(...) {
	chunks <- do.call(c, (lapply(list(...), chunkRef)))
	for (chunk in chunks) suppressWarnings(rm(list=c("to", "from"), chunk))
	x <- distObjRef(chunks)
	x
}
object.dsize <- function(x) sum(emerge(do.dcall("object.size", x)))
