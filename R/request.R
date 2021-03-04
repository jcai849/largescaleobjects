do.call.chunkStub <- function(what, args, target) {
	log(paste("requesting", format(what), 
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
	log(paste("requesting", format(what)))
	target <- findTarget(args)
	args <- lapply(args, stub, target=target)
	cs <- lapply(chunkStub(target), 
		     function(t) do.call.chunkStub(what, args, t))
	distObjStub(cs)
}

access <- function(x) {
	cd <- desc(x)
	log(paste("accessing chunk with descriptor", format(cd)))
	inform(cd)
	if (!checkKey(cd))
		read(queue(paste0(cd, "response")))
	clean(cd)
	populate(x)
}

inform <- function(cd) {
	log(paste("informing interest queue for chunk descriptor",
			 format(cd)))
	rediscc::redis.inc(getCommsConn(), paste0(cd, "interest"))
}

checkKey <- function(cd) {
	log(paste("checking availability of chunk descriptor",
			 format(cd)))
	!is.null(rediscc::redis.get(getCommsConn(), paste0(cd, "avail")))
}

clean <- function(cd) {
	log(paste("clearing interest for chunk descriptor",
			 format(cd)))
	rediscc::redis.dec(getCommsConn(), paste0(cd, "interest"))
}

populate <- function(x) {
	log(paste("populating stub for chunk descriptor", format(cd)))
	cd		<- desc(x)
	preview(x)	<- rediscc::redis.get(getCommsConn(), paste0(cd, "preview"))
	if (inherits(preview(x), "error")) stop(preview(x))	
	size(x)		<- rediscc::redis.get(getCommsConn(), paste0(cd, "size"))
	host(x)		<- rediscc::redis.get(getCommsConn(), paste0(cd, "host"))
	port(x)		<- rediscc::redis.get(getCommsConn(), paste0(cd, "port"))
	NULL
}

is.AsIs <- function(x) inherits(x, "AsIs")
unAsIs <- function(x) {
	class(x) <- class(x)[!class(x) == "AsIs"]
	x
}
