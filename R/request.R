do.ccall <- function(what, args, target, store=TRUE) { #call chunkRef
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

do.dcall <- function(what, args, store=TRUE) { #call distObjRef
	for (arg in args) fillMetaData(arg)
	## distribute the non-distributed
	target <- findTarget(args)
	args <- lapply(args, distribute, target=target)
	for (arg in args) fillMetaData(arg)
	##
	target <- findTarget(args)
	cs <- lapply(chunkRef(target), 
		     function(t) do.ccall(what, args, t, store))
	distObjRef(cs)
}

dreducable <- function(f) {
	function(x, y) {
		do.ccall(f, list(x, y), target = y)
	}
}

dreduce <- function(f, x, init, right = FALSE, accumulate = FALSE) {
	Reduce(dreducable(f), chunkRef(x), init, right, accumulate)
}
