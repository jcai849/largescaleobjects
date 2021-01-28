# Instantiate

distObjStub <- function(x) {
	stopifnot(all(sapply(x, is.chunkStub)))
	info("Producing new distributed object reference")
	dos <- new.env()
	class(dos) <- "distObjStub"
	chunkStub(dos) <- x
	resolution(dos) <- FALSE
	dos
}

# Inherit

is.distObjStub <- isA("distObjStub")

# Get

distObjDo <- function(fun, rtype) function(x) vapply(chunkStub(x), fun, rtype(1))
distObjResDo <- function(fun, rtype) function(x) { 
	resolve(x) 
	distObjDo(fun, rtype)(x)
}

chunkStub.distObjStub	<- envGet("chunk")
resolution.distObjStub	<- envGet("resolution")
size.distObjStub 	<- distObjResDo(size, integer)
to.distObjStub		<- distObjResDo(to,   integer)
from.distObjStub 	<- distObjResDo(from, integer)

# Set

distObjSet <- function(fun) function(x, value) {
	mapply(fun, chunkStub(x), value)
	x
}

`chunkStub<-.distObjStub`	<- envSet("chunk")
`resolution<-.distObjStub`	<- envSet("resolution")
`to<-.distObjStub`		<- distObjSet(`to<-`)
`from<-.distObjStub`		<- distObjSet(`from<-`)

# Other methods

resolve.distObjStub <- function(x) {
	if (resolution(x)) return(resolution(x))
	distObjDo(resolve, logical)(x)
	tos <- cumsum(size(x))
	names(tos) <- NULL
	to(x) <- tos
	froms <- c(1L, tos[-length(chunk(x))] + 1L)
	names(froms) <- NULL
	from(x) <- froms
	resolution(x) <- TRUE
}

emerge.distObjStub <- function(x) {
	chunks <- lapply(chunkStub(x), emerge)
	names(chunks) <- NULL
	if (length(chunks) == 1)
		return(chunks[[1]])
	do.call(combine, chunks)
}

print.distObjStub <- function(x, ...) {
	if (!resolution(x)) {
		cat("Not yet resolved. Resolving...\n")
		resolve(x)
	}
	cat("Distributed Object Stub. First chunk head:\n")
	print(chunkStub(x)[[1]])
	cat("With", format(length(chunkStub(x))), 
	    "chunk stubs, representing a size of",
	    format(sum(size(x))), "\n")
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
	mapped <- emerge(do.call.distObjStub(.Generic,
					    c(list(...), list(na.rm=I(na.rm)))))
	do.call(.Generic, 
		c(list(mapped), list(na.rm=na.rm)))
}

`$.distObjStub` <- function(x, name)
	do.call.distObjStub("$", list(x=x, name=I(name)))

table.distObjStub <- function(...)
	emerge(do.call.distObjStub("table",
				  list(...)))

dim.distObjStub <- function(x) {
	dims <- sapply(chunk(do.call.distObjStub("dim", list(x=x))), emerge)
	c(sum(dims[1,]), dims[,1][-1])
}
