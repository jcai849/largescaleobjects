do.call.chunkStub <- function(what, args, target) {
	stopifnot(is.list(args))
	resolve(target) # force target resolution
	d <- desc("chunk")
	send(fun	= what, 
	     args	= args,
	     target	= target,
	     desc	= d,
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
	rediscc::redis.push(commConn(), loc, serializedMsg)
}

access <- function(x) {
	cd <- desc(x)
	inform(cd)
	if (!checkKey(cd))
		read(queue(paste0("response", cd)))
	clean(cd)
	populate(x)
}

inform <- function(cd) 
	rediscc::redis.inc(commsConn(), paste0("interest", cd))

checkKey <- function(cd) 
	!is.null(rediscc::redis.get(commsConn(), paste0("avail", cd)))

clean <- function(cd)
	rediscc::redis.dec(commsConn(), paste0("interest", cd))

populate <- function(x) {
	cd		<- desc(x)
	preview(x)	<- rediscc::redis.get(commConn(), paste0(cd, "preview"))
	if (inherits("error", preview(x))) stop(preview(x))	
	size(x)		<- rediscc::redis.get(commConn(), paste0(cd, "size"))
	host(x)		<- rediscc::redis.get(commConn(), paste0(cd, "host"))
	port(x)		<- rediscc::redis.get(commConn(), paste0(cd, "port"))
	NULL
}
