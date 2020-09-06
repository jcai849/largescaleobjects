# Get
envGet <- function(field) function(x) get(field, x)

chunkID.chunkRef 	<- envGet("CHUNK_ID")
jobID.chunkRef 		<- envGet("JOB_ID")
resolution.chunkRef 	<- envGet("RESOLUTION")

preview.chunkRef	<- function(x) {resolve(x); envGet("PREVIEW")(x)}
preview.chunkID 	<- function(x, size=6L) head(chunk(x), n=size)
preview.default 	<- utils::head

# Set
envSet <- function(field) function(x, value) {
	assign(field, value, x)
	x
}

`chunkID<-.chunkRef` 	<- envSet("CHUNK_ID")
`jobID<-.chunkRef` 	<- envSet("JOB_ID")
`preview<-.chunkRef` 	<- envSet("PREVIEW")
`resolution<-.chunkRef`	<- envSet("RESOLUTION")

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

# Other methods

format.chunkRef	<- function(x, ...) format(preview(x))
print.chunkRef 	<- function(x, ...) print(preview(x))

resolve.chunkRef <- function(x, ...) {
	if (!resolved(x)) {
		info("Chunk not yet resolved. Resolving...")
		m <- read.queue(jobID(x), clear=TRUE)
		resolution(x) <- resolution(m)
		preview(x) <- preview(m)
		if (!identical(resolution(m), "RESOLVED")) stop(resolution(m))
	} 
	resolved(x)
}

resolved.chunkRef <- function(x, ...) {
	if (identical(resolution(x), "RESOLVED")) return(TRUE)
	if (identical(resolution(x), "UNRESOLVED")) return(FALSE)
	else stop(resolution(x))
}
