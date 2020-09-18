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
size.distObjRef 	<- function(x) vapply(chunk(x), size, integer())
to.distObjRef		<- function(x) vapply(chunk(x), to, integer())
from.distObjRef 	<- function(x) vapply(chunk(x), from, integer())

# Set

`chunk<-.distObjRef`	<- envSet("CHUNK")
