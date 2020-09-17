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

is.distObjRef <- function(x) inherits(x, "distObjRef")

# Get

chunk.distObjRef	<- envGet("CHUNK")
size.distObjRef 	<- envGet("SIZE")
to.distObjRef		<- function(x) sapply(chunk(x), to)
from.distObjRef 	<- function(x) sapply(chunk(x), from)

# Set

`chunk<-.distObjRef`	<- envSet("CHUNK")
