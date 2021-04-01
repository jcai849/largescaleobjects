do.call.chunkStub <- function(what, args, target, store=TRUE) {
	stopifnot(is.list(args))
	cd <- if (store) desc("chunk") else NULL
	send(fun	= what, 
	     args	= args,
	     target	= target,
	     desc	= cd,
	     loc	= desc(target),
	     store	= store)
	if (store) chunkStub(cd)
}

do.call.distObjStub <- function(what, args, store=TRUE) {
	for (arg in args) fillMetaData(arg)
	## distribute the non-distributed
	target <- findTarget(args)
	args <- lapply(args, stub, target=target)
	for (arg in args) fillMetaData(arg)
	##
	target <- findTarget(args)
	cs <- lapply(chunkStub(target), 
		     function(t) do.call.chunkStub(what, args, t, store))
	distObjStub(cs)
}
