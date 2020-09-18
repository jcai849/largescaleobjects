# Instantiate
chunkRef.chunkID <- function(x, jID)  {
	info("Producing new chunk reference with",
	     "chunk ID:", format(x), 
	     "and job ID:", format(jID))
	cr <- new.env()
	class(cr) <- "chunkRef"
	chunkID(cr) <- x
	jobID(cr) <- jID
	resolution(cr) <- "UNRESOLVED"
	cr
}

# Coerce

as.chunkRef.msg	<- function(x) {
	cr <- chunkRef(anteChunkID(x), anteJobID(x))
	resolution(cr) <- "RESOLVED"
	preview(cr) <- NA
	cr
}

# Get

chunkID.chunkRef 	<- envGet("CHUNK_ID")
jobID.chunkRef 		<- envGet("JOB_ID")
resolution.chunkRef 	<- envGet("RESOLUTION")
preview.default 	<- utils::head
preview.chunkRef	<- function(x) 
	if (hasName(x, "PREVIEW")) envGet("PREVIEW")(x) else
		"Chunk not yet resolved"
to.chunkRef 		<- envGet("TO")
from.chunkRef 		<- envGet("FROM")
size.chunkRef 		<- envGet("SIZE")

# Set

`chunkID<-.chunkRef` 	<- envSet("CHUNK_ID")
`jobID<-.chunkRef` 	<- envSet("JOB_ID")
`preview<-.chunkRef` 	<- envSet("PREVIEW")
`resolution<-.chunkRef`	<- envSet("RESOLUTION")
`to<-.chunkRef` 	<- envSet("TO")
`from<-.chunkRef`	<- envSet("FROM")
`size<-.chunkRef` 	<- envSet("SIZE")

# Other methods

emerge.chunkRef <- function(x, ...) {
	chunk.chunkRef(x)
}

format.chunkRef	<- function(x, ...) format(preview(x))
print.chunkRef 	<- function(x, ...) {
	cat("Chunk Reference with ID", format(chunkID(x)), "\n")
	resolve(x)
	cat(format(x), "\n")
}

resolve.chunkRef <- function(x, ...) {
	if (!resolved(x)) {
		info("Chunk not yet resolved. Resolving...")
		m <- read.queue(jobID(x), clear=TRUE)
		resolution(x) <- resolution(m)
		preview(x) <- preview(m)
		if (identical(resolution(x), "ERROR")) stop(preview(x))
	} 
	resolved(x)
}

resolved.chunkRef <- function(x, ...) {
	if (identical(resolution(x), "RESOLVED")) return(TRUE)
	if (identical(resolution(x), "UNRESOLVED")) return(FALSE)
	else stop(preview(x))
}
