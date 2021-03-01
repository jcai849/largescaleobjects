do.call.chunkStub <- function(what, args, target) {
	ulog::ulog(paste("requesting", format(what), 
			 "from target", format(desc(target))))
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
	ulog::ulog(paste("requesting", format(what)))
	target <- findTarget(args)
	args <- lapply(args, stub, target=target)
	cs <- lapply(chunkStub(target), 
		     function(t) do.call.chunkStub(what, args, t))
	distObjStub(cs)
}

send <- function(..., loc) {
	m <- msg(...)
	ulog::ulog(paste("sending msg:", format(m), "to", format("loc")))
	serializedMsg <- rawToChar(serialize(m, NULL, T))
	rediscc::redis.push(getCommsConn(), loc, serializedMsg)
}

access <- function(x) {
	cd <- desc(x)
	ulog::ulog(paste("accessing chunk with descriptor", format(cd)))
	inform(cd)
	if (!checkKey(cd))
		read(queue(paste0(cd, "response")))
	clean(cd)
	populate(x)
}

inform <- function(cd) {
	ulog::ulog(paste("informing interest queue for chunk descriptor",
			 format(cd)))
	rediscc::redis.inc(getCommsConn(), paste0(cd, "interest"))
}

checkKey <- function(cd) {
	ulog::ulog(paste("checking availability of chunk descriptor",
			 format(cd)))
	!is.null(rediscc::redis.get(getCommsConn(), paste0(cd, "avail")))
}

clean <- function(cd) {
	ulog::ulog(paste("clearing interest for chunk descriptor",
			 format(cd)))
	rediscc::redis.dec(getCommsConn(), paste0(cd, "interest"))
}

populate <- function(x) {
	ulog::ulog(paste("populating stub for chunk descriptor", format(cd)))
	cd		<- desc(x)
	preview(x)	<- rediscc::redis.get(getCommsConn(), paste0(cd, "preview"))
	if (inherits(preview(x), "error")) stop(preview(x))	
	size(x)		<- rediscc::redis.get(getCommsConn(), paste0(cd, "size"))
	host(x)		<- rediscc::redis.get(getCommsConn(), paste0(cd, "host"))
	port(x)		<- rediscc::redis.get(getCommsConn(), paste0(cd, "port"))
	NULL
}
