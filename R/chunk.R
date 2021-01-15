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

desc.chunkStub		<- envGet("CHUNK_DESC")
resolution.chunkStub	<- envGet("RESOLUTION")
host.chunkStub		<- envGet("HOST")
port.chunkStub		<- envGet("PORT")
preview.chunkStub	<- function(x) 
	if (hasName(x, "PREVIEW")) envGet("PREVIEW")(x) else
		"Error in preview"
to.chunkStub 		<- envGet("TO")
from.chunkStub 		<- envGet("FROM")
size.chunkStub 		<- envGet("SIZE")

# Set

`desc<-.chunkStub`	<- envSet("CHUNK_DESC")
`preview<-.chunkStub` 	<- envSet("PREVIEW")
`resolution<-.chunkStub`<- envSet("RESOLUTION")
`to<-.chunkStub` 	<- envSet("TO")
`from<-.chunkStub`	<- envSet("FROM")
`size<-.chunkStub` 	<- envSet("SIZE")
`port<-.chunkStub` 	<- envSet("PORT")
`host<-.chunkStub` 	<- envSet("HOST")

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
	if (!resolved(x)) {
		info("Chunk not yet resolved. Resolving...")
		resolution(x)	<- resolution(m)
		if (is.NA(resolution(x))) stop(preview(x))
		preview(x)	<- preview(m)
		size(x)		<- size(m)
		host(x)		<- host(m)
		port(x)		<- port(m)
	} 
	resolved(x)
}
