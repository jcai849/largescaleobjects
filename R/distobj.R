# Instantiate

# x is list of chunks
distObjRef <- function(x) {
	info("Producing new distributed object reference")
	dr <- new.env()
	class(dr) <- "distObjRef"
	chunk(dr) <- x
	resolution(dr) <- "UNRESOLVED"
	dr
}

# Inherit

is.distObjRef <- isA("distObjRef")

# Get

distObjDo <- function(fun, rtype) function(x) vapply(chunk(x), fun, rtype(1))
distObjResDo <- function(fun, rtype) function(x) { 
	resolve(x) 
	distObjDo(fun, rtype)(x)
}

chunk.distObjRef	<- envGet("CHUNK")
size.distObjRef 	<- distObjResDo(size, integer)
to.distObjRef		<- distObjResDo(to,   integer)
from.distObjRef 	<- distObjResDo(from, integer)
resolved.distObjRef	<- function(x) envGet("RESOLUTION")(x) == "RESOLVED"

# Set

distObjSet <- function(fun) function(x, value) {
	mapply(fun, chunk(x), value)
	x
}

`chunk<-.distObjRef`		<- envSet("CHUNK")
`to<-.distObjRef`		<- distObjSet(`to<-`)
`from<-.distObjRef`		<- distObjSet(`from<-`)
`resolution<-.distObjRef`	<- envSet("RESOLUTION")

# Other methods

resolve.distObjRef <- function(x) {
	r <- resolved(x)
	if (r) return(T)
	distObjDo(resolve, logical)(x)
	resolution(x) <- "RESOLVED"
	tos <- cumsum(size(x))
	names(tos) <- NULL
	to(x) <- tos
	froms <- c(1L, tos[-length(chunk(x))] + 1L)
	names(froms) <- NULL
	from(x) <- froms
	T
}

emerge.distObjRef <- function(x) {
	chunks <- lapply(chunk(x), emerge)
	names(chunks) <- NULL
	if (length(chunks) == 1)
		return(chunks[[1]])
	do.call(combine, chunks)
}

print.distObjRef <- function(x, ...) {
	if (!resolved(x)) {
		cat("Not yet resolved. Resolving...\n")
		resolve(x)
	}
	cat("Distributed object reference. First chunk head:\n")
	print(chunk(x)[[1]])
	cat("With", format(length(chunk(x))), "chunks, and size",
	    format(sum(size(x))), "\n")
}

# User-level

Math.distObjRef <- function(x, ...) 
	do.call.distObjRef(.Generic, 
			   c(list(x=x), list(...)))
Ops.distObjRef <- function(e1, e2) 
	if (missing(e2)) {
		do.call.distObjRef(.Generic,
				   list(e1=e1)) 
	} else
		do.call.distObjRef(.Generic,
				   list(e1=e1, e2=e2))
Complex.distObjRef <- function(z) 
	do.call.distObjRef(.Generic,
			   list(z=z))
Summary.distObjRef <- function(..., na.rm = FALSE) {
	mapped <- emerge(do.call.distObjRef(.Generic,
					    c(list(...), list(na.rm=I(na.rm)))))
	do.call(.Generic, 
		c(list(mapped), list(na.rm=na.rm)))
}
`$.distObjRef` <- function(x, name)
	do.call.distObjRef("$", list(x=x, name=I(name)))
table.distObjRef <- function(...)
	emerge(do.call.distObjRef("table",
				  list(...)))
read.csv.distObjRef <- function(...)
	do.call.distObjRef("read.csv", list(...))
dim.distObjRef <- function(x) {
	dims <- sapply(chunk(do.call.distObjRef("dim", list(x=x))), emerge)
	c(sum(dims[1,]), dims[,1][-1])
}
