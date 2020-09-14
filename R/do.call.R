do.call.chunkRef <- function(what, args, target, assign=TRUE) {
	stopifnot(is.list(args))
	resolved(target) # raise error if chunk resolved as failure
	jID <- jobID()
	cID <- if (assign) chunkID()
	info("Requested to perform function", format(what), 
	     "with parameters", format(names(args)), 
	     "set to", format(args), "using chunk", format(chunkID(target)),
	     "as target,", 
	     if (assign)  c("and assigning to chunk ID", format(cID)) else 
		     "with value return expected")
	if (assign)  {
		send(FUN = what, ARGS = args,
		     ANTE_CHUNK_ID = chunkID(target), ANTE_JOB_ID = jobID(target),
		     POST_CHUNK_ID = cID, POST_JOB_ID = jID,
		     to = chunkID(target))
	} else {
		send(FUN = what, ARGS = args,
		     ANTE_CHUNK_ID = chunkID(target), ANTE_JOB_ID = jobID(target),
		     POST_JOB_ID = jID, to = chunkID(target))
	}
	# output reference or value
	if (assign) chunkRef(cID, jID) else 
		resolution(read.queue(jID, clear=TRUE))
}

do.call.msg <- function(what, args, target, assign) {
	stopifnot(is.list(args))
	args <- lapply(args, refToRec, target=as.chunkRef(target))
	info("Requested to perform function", format(what), 
	     "with parameters", format(names(args)), 
	     "set to", format(args), "using chunk", format(anteChunkID(target)), 
	     "as target, ",
	     if (assign)  c("and assigning to chunk ID", 
			    format(postChunkID(target))) else 
				    "and returning value")
	do.call(what, args)
}

do.call.distObjRef <- function(what, args, assign=TRUE) {
	target <- findTarget(args)
	postChunks <- lapply(chunk(target), function(c) 
			     do.call.chunkRef(what, args, c, assign=assign))
	distObjRef(postChunks)
}
