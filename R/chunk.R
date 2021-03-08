# Instantiate

chunkStub.integer <- function(cd)  {
	cs <- new.env()
	class(cs) <- "chunkStub"
	desc(cs) <- cd 
	preview(cs) <- "/"
	resolved(cs) <- FALSE
	cs
}

root <- function() {
	cs <- new.env()
	class(cs) <- "chunkStub"
	desc(cs) <- "/" 
	preview(cs) <- "/"
	resolved(cs) <- TRUE
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
resolved.chunkStub	<- largeScaleR:::envGet("resolved")
size.chunkStub 		<- largeScaleR:::envGet("size")
to.chunkStub 		<- largeScaleR:::envGet("to")

# Set

`desc<-.chunkStub`	<- largeScaleR:::envSet("desc")
`from<-.chunkStub`	<- largeScaleR:::envSet("from")
`host<-.chunkStub` 	<- largeScaleR:::envSet("host")
`isEndPosition<-.chunkStub`<- largeScaleR:::envSet("isEndPosition")
`port<-.chunkStub` 	<- largeScaleR:::envSet("port")
`preview<-.chunkStub` 	<- largeScaleR:::envSet("preview")
`resolved<-.chunkStub`	<- largeScaleR:::envSet("resolved")
`size<-.chunkStub` 	<- largeScaleR:::envSet("size")
`to<-.chunkStub` 	<- largeScaleR:::envSet("to")

# Other methods

format.chunkStub	<- function(x, ...) {
	paste("Chunk Reference with Descriptor:", format(desc(x)), 
	      if (resolved(x)) {
		      paste("and size:", format(size(x)), 
			    "\n", "Preview:", "\n", format(preview(x)), "...\n",
			    collapse="\n") 
	      } else ". Chunk unresolved\n")
}

print.chunkStub 	<- function(x, ...) {
	cat("Chunk Reference with Descriptor", format(desc(x)))
	if (resolved(x)) {
		cat(" and size", format(size(x)), 
		    "\n", "Preview:", "\n", format(preview(x)), "...\n")
	} else cat(". Chunk unresolved\n")
}

resolve.chunkStub <- function(x, ...) {
	if (!resolved(x)) {
		access(x)
		resolved(x) <- TRUE
	} 
	x
}
