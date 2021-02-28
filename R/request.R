do.call.chunkStub <- function(what, args, target) {
	stopifnot(is.list(args))
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
	args <- lapply(args, stub, target=target)
	cs <- lapply(chunkStub(target), 
		     function(t) do.call.chunkStub(what, args, t))
	distObjStub(cs)
}

send <- function(..., loc) {
	m <- msg(...)
	serializedMsg <- rawToChar(serialize(m, NULL, T))
	rediscc::redis.push(getCommsConn(), loc, serializedMsg)
}

access <- function(x) {
	cd <- desc(x)
	inform(cd)
	if (!checkKey(cd))
		read(queue(paste0(cd, "response")))
	clean(cd)
	populate(x)
}

inform <- function(cd) 
	rediscc::redis.inc(getCommsConn(), paste0(cd, "interest"))

checkKey <- function(cd) 
	!is.null(rediscc::redis.get(getCommsConn(), paste0(cd, "avail")))

clean <- function(cd)
	rediscc::redis.dec(getCommsConn(), paste0(cd, "interest"))

populate <- function(x) {
	cd		<- desc(x)
	preview(x)	<- rediscc::redis.get(getCommsConn(), paste0(cd, "preview"))
	if (inherits(preview(x), "error")) stop(preview(x))	
	size(x)		<- rediscc::redis.get(getCommsConn(), paste0(cd, "size"))
	host(x)		<- rediscc::redis.get(getCommsConn(), paste0(cd, "host"))
	port(x)		<- rediscc::redis.get(getCommsConn(), paste0(cd, "port"))
	NULL
}
