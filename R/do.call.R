do.call.chunkRef <- function(what, args, target) {
	stopifnot(is.list(args))
	resolve(target) # force target resolution
	jID <- jobID()
	cID <- name(type="chunkDesc")
	send(FUN		= what, 
	     ARGS		= args,
	     TARGET		= target,
	     POST_CHUNK_ID	= cID,
	     POST_JOB_ID	= jID,
	     to			= name(target))
	chunkRef(cID, jID)
}

do.call.msg <- function(what, args, target, pCID, pJID) {
	stopifnot(is.list(args))
	args <- lapply(args, refToRec, target=target)
	info("Requested to perform function", format(what),
	     "using chunk", format(chunkDesc(target)), 
	     "as target, and assigning to chunk ID", format(pCID))
	do.call(what, args)
}

do.call.distObjRef <- function(what, args) {
	target <- findTarget(args)
	args <- lapply(args, function(arg) 
		       if (!is.distributed(arg) && size(arg) == 1L) I(arg) else 
			       recToRef(arg, target))
	lapply(args, resolve)
	postChunks <- lapply(chunk(target), 
			     function(t) do.call.chunkRef(what, args, t))
	distObjRef(postChunks)
}
