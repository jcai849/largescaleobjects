# Instantiate

chunkStub.integer <- function(cd)  {
	info("Producing new chunk stub with",
	     "chunk Descriptor:", format(cd)) 
	cs <- new.env()
	class(cs) <- "chunkStub"
	desc(cs) <- cd 
	resolved(cs) <- FALSE
	cs
}

root <- function() {
	cs <- new.env()
	class(cs) <- "chunkStub"
	desc(cs) <- "/" 
	resolved(cs) <- TRUE
	cs
}

# Inherit

is.chunkStub <- largeScaleR:::isA("chunkStub")

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

format.chunkStub	<- function(x, ...) format(preview(x))
print.chunkStub 	<- function(x, ...) {
	cat("Chunk Reference with Descriptor", format(desc(x)), "\n")
	if (resolved(x)) print(preview(x)) else cat("unresolved\n")
}

resolve.chunkStub <- function(x, ...) {
	if (!resolved(x)) {
		info("Chunk not yet resolved. Resolving...")
		access(x)
		resolved(x) <- TRUE
	} 
}
