do.call.chunkStub <- function(what, args, target) {
	stopifnot(is.list(args))
	resolve(target) # force target resolution
	d <- desc("chunk")
	request(FUN		= what, 
		ARGS		= args,
		TARGET		= target,
		DESC		= d)
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

request <- function(..., cd) {
	m <- msg(...)
	serializedMsg <- rawToChar(serialize(m, NULL, T))
	info("writing message:", format(m), 
	     "to queue belonging to chunk", cd)
	rediscc::redis.push(commConn(), cd, serializedMsg)
}

# Access of object details
access <- function(x) {
	cd <- desc(x)
	inform(cd)
	if (!checkKey(cd))
		await(cd)
	clean(cd)
	populate(x)
}

inform <- function(cd) {}
checkKey <- function(cd) {}
await <- function(cd) {}
clean <- function(cd) {}
populate <- function(x) {}
