# Instantiate

chunkStub.integer <- function(cd)  {
	info("Producing new chunk reference with",
	     "chunk Descriptor:", format(cd)) 
	cs <- new.env()
	class(cs) <- "chunkStub"
	chunkDesc(cs) <- cd 
	resolution(cs) <- FALSE
	cs
}

# Inherit

is.chunkStub <- largeScaleR:::isA("chunkStub")

# Get

desc.chunkStub		<- largeScaleR:::envGet("desc")
resolution.chunkStub	<- largeScaleR:::envGet("resolution")
host.chunkStub		<- largeScaleR:::envGet("host")
port.chunkStub		<- largeScaleR:::envGet("port")
preview.chunkStub	<- largeScaleR:::envGet("preview")
to.chunkStub 		<- largeScaleR:::envGet("to")
from.chunkStub 		<- largeScaleR:::envGet("from")
size.chunkStub 		<- largeScaleR:::envGet("size")

# Set

`desc<-.chunkStub`	<- largeScaleR:::envSet("desc")
`preview<-.chunkStub` 	<- largeScaleR:::envSet("preview")
`resolution<-.chunkStub`<- largeScaleR:::envSet("resolution")
`to<-.chunkStub` 	<- largeScaleR:::envSet("to")
`from<-.chunkStub`	<- largeScaleR:::envSet("from")
`size<-.chunkStub` 	<- largeScaleR:::envSet("size")
`port<-.chunkStub` 	<- largeScaleR:::envSet("port")
`host<-.chunkStub` 	<- largeScaleR:::envSet("host")

# Other methods

emerge.chunkStub <- function(x, ...) 
	tryCatch(get(desc(x), envir = .largeScaleRChunks),
		 error = function(e) {
			 resolve(x)
			 osrvGet(x)
		 })
format.chunkStub	<- function(x, ...) format(preview(x))
print.chunkStub 	<- function(x, ...) {
	cat("Chunk Reference with Descriptor", format(desc(x)), "\n")
	resolve(x)
	print(preview(x))
}

resolve.chunkStub <- function(x, ...) {
	if (!resolution(x)) {
		info("Chunk not yet resolved. Resolving...")
		access(x)
		resolution(x) <- TRUE
	} 
}
