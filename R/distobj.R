# Instantiate

# x is list of chunks
distObjRef <- function(x) {
	info("Producing new distributed object reference")
	dr <- new.env()
	class(dr) <- "distObjRef"
	chunk(dr) <- x
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
resolved.distObjRef	<- distObjDo(resolved, logical)

# Set

distObjSet <- function(fun) function(x, value) {
	mapply(fun, chunk(x), value)
	x
}

`chunk<-.distObjRef`		<- envSet("CHUNK")
`to<-.distObjRef`		<- distObjSet(`to<-`)
`from<-.distObjRef`		<- distObjSet(`from<-`)

# Other methods

resolve.distObjRef <- function(x) {
	r <- all(resolved(x))
	if (r) return(r)
	distObjDo(resolve, logical)(x)
	tos <- cumsum(size(x))
	to(x) <- tos
	from(x) <- c(1L, tos[-length(chunk(x))] + 1L)
	r
}

emerge.distObjRef <- function(x) {
	chunks <- lapply(chunk(x), emerge)
	names(chunks) <- NULL
	do.call(combine, chunks)
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
Summary.distObjRef <- function(..., na.rm = FALSE) 
	do.call(.Generic, c(list(emerge(do.call.distObjRef(.Generic,
				   c(list(...), list(na.rm=I(na.rm)))))), 
			    list(na.rm=na.rm)))
table.distObjRef <- function(...)
	emerge(do.call.distObjRef(table,
				  list(...)))
