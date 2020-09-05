# chunkRef methods

jobID.chunkRef <- function(x, ...) get("JOB_ID", x)

chunkID.chunkRef <- function(x, ...) get("CHUNK_ID", x)

do.call.chunkRef <- function(what, chunkArg, distArgs=NULL, staticArgs=NULL,
			     assign=TRUE) {
	jID <- jobID()
	cID <- if (assign) chunkID() else NULL
	cat("Requesting to perform function", format(what), "on chunk",
	    chunkID(chunkArg), "with", 
	    if (assign) "assignment" else "no assignment", "\n")
	send(OP = if (assign) "ASSIGN" else "DOFUN", FUN = what, 
	     CHUNK = chunkArg, DIST_ARGS = distArgs, STATIC_ARGS = staticArgs,
	     JOB_ID = jID, CHUNK_ID = cID, to = chunkID(chunkArg))

	# output reference or value
	if (assign) chunkRef(cID, jID) else resolution(read.queue(jID, clear=TRUE))
}

format.chunkRef <- function(x, ...) format(preview(x))
print.chunkRef <- function(x, ...) print(preview(x))

preview <- function(x, ...) UseMethod("preview", x)
preview.chunkRef <- function(x) { resolve(x); get("PREVIEW", x) }
preview.chunkID <- function(x, size=6L) head(get(x), n=size)

`preview<-` <- function(x, value) UseMethod("preview<-", x)
`preview<-.chunkRef` <- function(x, value) {
	assign("PREVIEW", value, x)
	x
}

resolve <- function(x, ...) UseMethod("resolve", x)
resolve.chunkRef <- function(x, ...) {
	if (!resolved(x)) {
		m <- read.queue(jobID(x), clear=TRUE)
		if (!identical(resolution(m), "RESOLVED")) stop(resolution(m))
		resolution(x) <- resolution(m)
		preview(x) <- preview(m)
	} 
	resolved(x)
}

resolved <- function(x, ...) UseMethod("resolved", x)
resolved.chunkRef <- function(x, ...) {
	if (identical(resolution(x), "RESOLVED")) return(TRUE)
	if (identical(resolution(x), "UNRESOLVED")) return(FALSE)
	else stop(resolution(x))
}

resolution <- function(x, ...) UseMethod("resolution", x)
resolution.chunkRef <- function(x, ...) get("RESOLUTION", x)

`resolution<-` <- function(x, value) UseMethod("resolution<-", x)
`resolution<-.chunkRef` <- function(x, value) {
	assign("RESOLUTION", value, x)
	x
}
