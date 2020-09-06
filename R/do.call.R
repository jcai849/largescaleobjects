do.call.chunkRef <- function(what, chunkArg, distArgs=NULL, staticArgs=NULL,
			     assign=TRUE) {
	resolved(chunkArg) # raise error if chunk resolved as failure
	jID <- jobID()
	cID <- if (assign) chunkID() else NULL
	info("Requesting to perform function", format(what), 
	     "on chunk", chunkID(chunkArg), "with", 
	    if (assign) "assignment" else "no assignment")
	send(OP = if (assign) "ASSIGN" else "DOFUN", FUN = what, 
	     CHUNK = chunkArg, DIST_ARGS = distArgs, STATIC_ARGS = staticArgs,
	     JOB_ID = jID, CHUNK_ID = cID, to = chunkID(chunkArg))
	# output reference or value
	if (assign) chunkRef(cID, jID) else resolution(read.queue(jID, clear=TRUE))
}

do.call.chunk <- function(what, chunkArg, distArgs, staticArgs, jID, cID) {
	info("Requested to perform function", format(what))
	if (!missing(cID)) {
		v <- tryCatch({
				res <- do.call(what, list(chunkArg))
				send(RESOLUTION = "RESOLVED", 
				     PREVIEW = preview(res), to = jID)
				res},
			error = function(e) {
				info("Error occured:", format(e$message))
				send(RESOLUTION = e, to = jID)
				e})
		addChunk(cID, v)
	} else tryCatch({
				res <- do.call(what, list(chunkArg))
				send(RESOLUTION = res, to = jID) }, 
		error = function(e) {
				info("Error occured:", format(e$message))
				send(RESOLUTION = e, to = jID)})
}
