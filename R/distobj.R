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

distObjGet <- function(fun) function(x) vapply(chunk(x), fun, integer(1))

chunk.distObjRef	<- envGet("CHUNK")
size.distObjRef 	<- distObjGet(size)
to.distObjRef		<- distObjGet(to)
from.distObjRef 	<- distObjGet(from)

# Set

`chunk<-.distObjRef`	<- envSet("CHUNK")
