# Instantiate

chunkStub.integer <- function(cd)  {
	cs <- new.env()
	class(cs) <- "chunkStub"
	desc(cs) <- cd 
	cached(cs) <- FALSE
	cs
}

root <- function() {
	cs <- new.env()
	class(cs) <- "chunkStub"
	desc(cs) <- "/" 
	cached(cs) <- TRUE
	cs
}

# Inherit

is.chunkStub <- largeScaleR:::isA("chunkStub")

# Get

desc.chunkStub		<- largeScaleR:::envGet("desc")
cached.chunkStub	<- largeScaleR:::envGet("cached")
host.chunkStub		<- largeScaleR:::envGet("host")
port.chunkStub		<- largeScaleR:::envGet("port")
preview.chunkStub	<- largeScaleR:::envGet("preview")
to.chunkStub 		<- largeScaleR:::envGet("to")
from.chunkStub 		<- largeScaleR:::envGet("from")
size.chunkStub 		<- largeScaleR:::envGet("size")

# Set

`desc<-.chunkStub`	<- largeScaleR:::envSet("desc")
`preview<-.chunkStub` 	<- largeScaleR:::envSet("preview")
`cached<-.chunkStub`<- largeScaleR:::envSet("cached")
`to<-.chunkStub` 	<- largeScaleR:::envSet("to")
`from<-.chunkStub`	<- largeScaleR:::envSet("from")
`size<-.chunkStub` 	<- largeScaleR:::envSet("size")
`port<-.chunkStub` 	<- largeScaleR:::envSet("port")
`host<-.chunkStub` 	<- largeScaleR:::envSet("host")

# Other methods

format.chunkStub	<- function(x, ...)
	paste("Chunk Reference with Descriptor:", format(desc(x)), "\n", 
	      if (cached(x)) format(preview(x)) else "uncached")

print.chunkStub 	<- function(x, ...) {
	cat("Chunk Reference with Descriptor", format(desc(x)), "\n")
	if (cached(x)) print(preview(x)) else cat("uncached\n")
}

cache.chunkStub <- function(x, ...) {
	if (!cached(x)) {
		access(x)
		cached(x) <- TRUE
	} 
	x
}
