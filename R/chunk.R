# Instantiate

chunkStub.integer <- function(cd)  {
	cs <- new.env()
	class(cs) <- "chunkStub"
	desc(cs) <- cd 
	preview(cs) <- "/"
	cached(cs) <- FALSE
	cs
}

root <- function() {
	cs <- new.env()
	class(cs) <- "chunkStub"
	desc(cs) <- "/" 
	preview(cs) <- "/"
	cached(cs) <- TRUE
	cs
}

# Inherit

is.chunkStub <- function(x) inherits(x, "chunkStub")

# Get

desc.chunkStub		<- largeScaleR:::envGet("desc")
from.chunkStub 		<- largeScaleR:::envGet("from")
host.chunkStub		<- largeScaleR:::envGet("host")
isEndPosition.chunkStub <- largeScaleR:::envGet("isEndPosition")
port.chunkStub		<- largeScaleR:::envGet("port")
preview.chunkStub	<- largeScaleR:::envGet("preview")
cached.chunkStub	<- largeScaleR:::envGet("cached")
size.chunkStub 		<- largeScaleR:::envGet("size")
to.chunkStub 		<- largeScaleR:::envGet("to")

# Set

`desc<-.chunkStub`	<- largeScaleR:::envSet("desc")
`from<-.chunkStub`	<- largeScaleR:::envSet("from")
`host<-.chunkStub` 	<- largeScaleR:::envSet("host")
`isEndPosition<-.chunkStub`<- largeScaleR:::envSet("isEndPosition")
`port<-.chunkStub` 	<- largeScaleR:::envSet("port")
`preview<-.chunkStub` 	<- largeScaleR:::envSet("preview")
`cached<-.chunkStub`	<- largeScaleR:::envSet("cached")
`size<-.chunkStub` 	<- largeScaleR:::envSet("size")
`to<-.chunkStub` 	<- largeScaleR:::envSet("to")

# Other methods

format.chunkStub	<- function(x, ...) {
	paste("Chunk Stub", format(desc(x)))
}

print.chunkStub 	<- function(x, ...) {
	cat("Chunk stub with Descriptor", format(desc(x)))
	if (cached(x)) {
		cat(" and size", format(size(x)), 
		    "\n", "Preview:", "\n")
		(preview(x))
		cat("...")
	} else cat(". Chunk uncached\n")
}

cache.chunkStub <- function(x, ...) {
	if (!cached(x)) {
		access(x)
		cached(x) <- TRUE
	} 
	x
}
