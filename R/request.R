do.call.chunkStub <- function(what, args, target) {
	stopifnot(is.list(args))
	resolve(target) # force target resolution
	d <- desc("chunk")
	send(FUN		= what, 
	     ARGS		= args,
	     TARGET		= target,
	     DESC		= d,
	     cd		= desc(target))
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

# Access of object details
access <- function(x) {
	cd <- desc(x)
	inform(cd)
	if (!checkKey(cd))
		read(paste0("COMPLETE", cd))
	clean(cd)
	populate(x)
}

inform <- function(cd) 
	rediscc::redis.inc(commsConn(), paste0("interest", cd))

checkKey <- function(cd) 
	!is.null(rediscc::redis.get(commsConn(), paste0("avail", cd)))

await <- function(cd)
clean <- function(cd) {}
populate <- function(x) {}
