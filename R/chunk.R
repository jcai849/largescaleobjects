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

is.chunkStub <- isA("chunkStub")

# Get

desc.chunkStub		<- envGet("desc")
resolution.chunkStub	<- envGet("resolution")
host.chunkStub		<- envGet("host")
port.chunkStub		<- envGet("port")
preview.chunkStub	<- envGet("preview")
to.chunkStub 		<- envGet("to")
from.chunkStub 		<- envGet("from")
size.chunkStub 		<- envGet("size")

# Set

`desc<-.chunkStub`	<- envSet("desc")
`preview<-.chunkStub` 	<- envSet("preview")
`resolution<-.chunkStub`<- envSet("resolution")
`to<-.chunkStub` 	<- envSet("to")
`from<-.chunkStub`	<- envSet("from")
`size<-.chunkStub` 	<- envSet("size")
`port<-.chunkStub` 	<- envSet("port")
`host<-.chunkStub` 	<- envSet("host")

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
