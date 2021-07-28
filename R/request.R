do.ccall <- function(what, args, target, store=TRUE, insert=NULL) {
	stopifnot(is.list(args), is.cref(target))
	cd <- if (store) cdesc() else NULL
	send(fun	= what, 
	     args	= args,
	     target	= target,
	     desc	= cd,
	     loc	= desc(target),
	     store	= store,
	     insert	= insert)
	if (store) cref(cd)
}

do.dcall <- function(what, args, store=TRUE, insert=NULL) {
	stopifnot(is.list(args))
	for (arg in args) fillMetaData(arg)
	target <- findTarget(args)
	args <- lapply(args, distribute, target=target)
	for (arg in args) fillMetaData(arg)
	target <- findTarget(args)
	cs <- lapply(cref(target), 
		     function(t) do.ccall(what, args, t, store, insert))
	dref(cs)
}

dreduce <- function(f, x, init, right = FALSE, accumulate = FALSE, ...) {
	Reduce(dreducable(f, ...), cref(x), init, right, accumulate)
}

dreducable <- function(f, ...) {
	function(x, y) {
		do.ccall(f, list(x, y), target = y, ...)
	}
}
