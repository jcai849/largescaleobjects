# Instantiate

distObjStub <- function(x) {
	stopifnot(all(sapply(x, is.chunkStub)))
	dos <- new.env()
	class(dos) <- "distObjStub"
	chunkStub(dos) <- x
	resolved(dos) <- FALSE
	isEndPosition(dos) <- c(rep(FALSE, length(x)-1), TRUE)
	dos
}

# Inherit

is.distObjStub <- function(x) inherits(x, "distObjStub")
is.distributed <- function(x) is.distObjStub(x) | is.chunkStub(x)

# Get

distObjDo <- function(fun, rtype) function(x) vapply(chunkStub(x), fun, rtype(1))

chunkStub.distObjStub	<- largeScaleR:::envGet("chunk")
resolved.distObjStub	<- largeScaleR:::envGet("resolved")
size.distObjStub 	<- distObjDo(size, integer)
to.distObjStub		<- distObjDo(to,   integer)
from.distObjStub 	<- distObjDo(from, integer)
isEndPosition.distObjStub<- distObjDo(isEndPosition, integer)

# Set

distObjSet <- function(fun) function(x, value) {
	mapply(fun, chunkStub(x), value)
	x
}

`chunkStub<-.distObjStub`	<- largeScaleR:::envSet("chunk")
`resolved<-.distObjStub`	<- largeScaleR:::envSet("resolved")
`to<-.distObjStub`		<- distObjSet(`to<-`)
`from<-.distObjStub`		<- distObjSet(`from<-`)
`isEndPosition<-.distObjStub`	<- distObjSet(`isEndPosition<-`)

# Other methods

resolve.distObjStub <- function(x) {
	if (resolved(x)) return(resolved(x))
	log("resolving distObjStub")
	lapply(chunkStub(x), resolve)
	tos <- cumsum(size(x))
	names(tos) <- NULL
	to(x) <- tos
	froms <- c(1L, to(x)[-length(to(x))] + 1L)
	names(froms) <- NULL
	from(x) <- froms
	resolved(x) <- TRUE
	x
}

print.distObjStub <- function(x, ...) {
	cat("Distributed Object Stub with", format(length(chunkStub(x))), 
	    "chunk stubs.")
	if (resolved(x)) {
		cat(" Total size", format(sum(size(x))), "\n")
		cat("First chunk stub:\n")
		print(chunkStub(x)[[1]])
	} else cat(" Chunks unresolved\n")
}

format.distObjStub <- function(x, ...) paste(
	"Distributed Object Stub with", format(length(chunkStub(x))), 
	    "chunk stubs.", 
	if (resolved(x)) {
		paste(
		" Total size:", format(sum(size(x))), "\n", 
		"First chunk:\n", format(chunkStub(x)[[1]]))
	} else cat(" Chunks unresolved.\n"))

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
					    c(list(...), list(na.rm=I(na.rm)))))
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
