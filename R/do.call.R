do.call.chunkRef <- function(what, args, target) {
	stopifnot(is.list(args))
	resolve(target) # force target resolution
	jID <- jobID()
	cID <- chunkID()
	info("Requesting to perform function", format(what), 
	     "with parameters", format(names(args)), 
	     "set to", format(args), "using chunk", format(chunkID(target)),
	     "as target, and assigning to chunk ID", format(cID))
	send(FUN		= what, 
	     ARGS		= args,
	     TARGET		= target,
	     POST_CHUNK_ID	= cID,
	     POST_JOB_ID	= jID,
	     to			= chunkID(target))
	chunkRef(cID, jID)
}

do.call.msg <- function(what, args, target, pCID, pJID) {
	stopifnot(is.list(args))
	args <- lapply(args, refToRec, target=target)
	info("Requested to perform function", format(what), 
	     "with parameters", format(names(args)), 
	     "set to", format(args), "using chunk", format(chunkID(target)), 
	     "as target, and assigning to chunk ID", format(pCID))
	do.call(what, args)
}

do.call.distObjRef <- function(what, args) {
	target <- findTarget(args)
	args <- lapply(args, recToRef, target=target)
	postChunks <- lapply(chunk(target), 
			     function(t) do.call.chunkRef(what, args, t))
	distObjRef(postChunks)
}
