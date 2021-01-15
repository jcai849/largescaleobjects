do.call.chunkStub <- function(what, args, target) {
	stopifnot(is.list(args))
	resolve(target) # force target resolution
	cd <- desc("chunk")
	request(FUN		= what, 
		ARGS		= args,
		TARGET		= target,
		CHUNK_DESC	= cd)
	chunkStub(cd)
}

do.call.distObjStub <- function(what, args) {
	target <- findTarget(args)
	args <- lapply(args, function(arg) 
		       if (!is.distributed(arg) && size(arg) == 1L) I(arg) else 
			       marshall(arg, target))
	lapply(args, resolve)
	cs <- lapply(chunkStub(target), 
			     function(t) do.call.chunkStub(what, args, t))
	distObjStub(cs)
}

request <- function(..., to) {
	serializedMsg <- rawToChar(serialize(m, NULL, T))
	info("writing message:", format(m), 
	     "to queue belonging to chunk", to)
	rediscc::redis.push(commConn(), to, serializedMsg)
}

# Access of object details
