do.call.chunkStub <- function(what, args, target) {
	stopifnot(is.list(args))
	resolve(target)
	cd <- desc("chunk")
	send(fun	= what, 
	     args	= args,
	     target	= target,
	     desc	= cd,
	     loc	= desc(target))
	chunkStub(cd)
}

do.call.distObjStub <- function(what, args) {
	target <- findTarget(args)
	args <- lapply(args, function(arg) 
		       if (!is.distributed(arg) && size(arg) == 1L) I(arg) else 
			       stub(arg, target))
	lapply(args, resolve)
	cs <- lapply(chunkStub(target), 
			     function(t) do.call.chunkStub(what, args, t))
	distObjStub(cs)
}

send <- function(..., loc) {
	m <- msg(...)
	serializedMsg <- rawToChar(serialize(m, NULL, T))
	rediscc::redis.push(commsConn(), loc, serializedMsg)
}

access <- function(x) {
	cd <- desc(x)
	send(fun = sendMetadata,
	     args = list(cd=cd),
	     target = NULL,
	     loc  = paste0(cd, "metadataRequest"),
	     store=FALSE)
	md <- read(queue(paste0(cd, "metadataResponse")))
	preview(x) <- preview(md)
	size(x) <- size(md)
	invisible(NULL)
}
