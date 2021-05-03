do.call.chunkRef <- function(what, args, target, store=TRUE) {
	stopifnot(is.list(args))
	cd <- if (store) desc("chunk") else NULL
	send(fun	= what, 
	     args	= args,
	     target	= target,
	     desc	= cd,
	     loc	= desc(target),
	     store	= store)
	if (store) chunkRef(cd)
}

do.call.distObjRef <- function(what, args, store=TRUE) {
	for (arg in args) fillMetaData(arg)
	## distribute the non-distributed
	target <- findTarget(args)
	args <- lapply(args, distribute, target=target)
	for (arg in args) fillMetaData(arg)
	##
	target <- findTarget(args)
	cs <- lapply(chunkRef(target), 
		     function(t) do.call.chunkRef(what, args, t, store))
	distObjRef(cs)
}
