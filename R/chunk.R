# distChunk methods

jobID.distChunk <- function(x, ...) get("JOB_ID", x)

chunkID.distChunk <- function(x, ...) {
	if (! exists("CHUNK_ID", x)) { 
		jID <- jobID(x)
		cat("chunkID not yet associated with distChunk; checking jobID",
		    jID, "\n")
		cID <- chunkID(read.queue(jID, clear=TRUE))
		cat("chunkID \"", format(cID), "\" found; associating...\n", 
		    sep="")
		chunkID(x) <- cID
	}
	get("CHUNK_ID", x)
}

do.call.distChunk <- function(what, chunkArg, distArgs=NULL, staticArgs=NULL, 
			      assign=TRUE, wait=FALSE) {
	jID <- jobID()
	cat("Requesting to perform function", format(what), "on chunk",
	    chunkID(chunkArg), "with", 
	    if (assign) "assignment" else "no assignment", "\n")
	send(OP = if (assign) "ASSIGN" else "DOFUN", FUN = what, 
	     CHUNK = chunkArg, DIST_ARGS = distArgs, STATIC_ARGS = staticArgs,
	     JOB_ID = jID, to = chunkID(chunkArg))

	dc <- if (assign) {
		if (!wait){
			cat("not waiting, using job ID", format(jID), "\n")
			distChunk(jID) 
		} else {
			distChunk(chunkID(read.queue(jID, clear=TRUE)))
	} } else {
		val(read.queue(jID, clear=TRUE))
	}
	dc	
}

format.distChunk <- function(x, ...) {
	c <- do.call.distChunk(identity, x, assign=FALSE)
	format(c)
}
