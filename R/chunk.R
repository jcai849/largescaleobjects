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
resolved.chunkStub	<- largeScaleR:::envGet("resolved")
host.chunkStub		<- largeScaleR:::envGet("host")
port.chunkStub		<- largeScaleR:::envGet("port")
preview.chunkStub	<- largeScaleR:::envGet("preview")
to.chunkStub 		<- largeScaleR:::envGet("to")
from.chunkStub 		<- largeScaleR:::envGet("from")
size.chunkStub 		<- largeScaleR:::envGet("size")

# Set

`desc<-.chunkStub`	<- largeScaleR:::envSet("desc")
`preview<-.chunkStub` 	<- largeScaleR:::envSet("preview")
`resolved<-.chunkStub`<- largeScaleR:::envSet("resolved")
`to<-.chunkStub` 	<- largeScaleR:::envSet("to")
`from<-.chunkStub`	<- largeScaleR:::envSet("from")
`size<-.chunkStub` 	<- largeScaleR:::envSet("size")
`port<-.chunkStub` 	<- largeScaleR:::envSet("port")
`host<-.chunkStub` 	<- largeScaleR:::envSet("host")

# Other methods

format.chunkStub	<- function(x, ...)
	paste("Chunk Reference with Descriptor:", format(desc(x)), "\n", 
	      if (resolved(x)) 
		      paste(format(preview(x)), collapse="\n") else 
			      " unresolved")

print.chunkStub 	<- function(x, ...) {
	cat("Chunk Reference with Descriptor", format(desc(x)), "\n")
	if (resolved(x)) print(preview(x)) else cat("unresolved\n")
}

resolve.chunkStub <- function(x, ...) {
	if (!resolved(x)) {
		access(x)
		resolved(x) <- TRUE
	} 
	x
}
