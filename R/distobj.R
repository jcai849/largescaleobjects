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

chunk.distObjRef	<- envGet("CHUNK")
size.distObjRef 	<- distObjDo(size, integer)
to.distObjRef		<- distObjDo(to,   integer)
from.distObjRef 	<- distObjDo(from, integer)

# Set

distObjSet <- function(fun) function(x, value) {
	mapply(fun, chunk(x), value)
	x
}

`chunk<-.distObjRef`	<- envSet("CHUNK")
`to<-.distObjRef`	<- distObjSet(`to<-`)
`from<-.distObjRef`	<- distObjSet(`from<-`)

# Other methods

resolve.distObjRef <- function(x) {
	r <- distObjDo(resolve, logical)(x)
	to(x) <- cumsum(size(x))
	from(x) <- c(1L, to(x)[-length(chunk(x))] + 1L)
	r
}
