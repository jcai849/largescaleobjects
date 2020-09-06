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

do.call.chunk <- function(what, chunkArg, distArgs, staticArgs, cID) {
	if (!missing(cID)) {
		v <- do.call(what, list(chunkArg))
		cat("Assigning value", format(v), "to identifier", 
		    format(cID), "\n")
		addChunk(cID, v)
		return("RESOLVED")
	} else do.call(what, list(chunkArg))
}
