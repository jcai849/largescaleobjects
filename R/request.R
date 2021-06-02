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

dreduce <- function(f, x, init) {
# remaining problem is chunk references -  change do.ccall with send and
# manually specify chunkref id for final chunk (don't store any but the last)
	r <- function(f, prev, curr) {
		res <- f(prev, curr)
		if (length(chunkRefs(curr)) == 1L)
			return(res)
		next <- chunkRefs(x)[-1][1]
		do.ccall(sys.function(), list(f = f, prev = res, curr = next),
			 target = next)
		invisible(NULL)
	}
	first <-  chunkRefs(x)[-1][1]
	do.ccall(r, list(f = f, prev = init, curr = first), target = first)
}
