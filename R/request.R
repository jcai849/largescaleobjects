do.call.chunkStub <- function(what, args, target, save=TRUE) {
	stopifnot(is.list(args))
	cd <- desc("chunk")
	send(fun	= what, 
	     args	= args,
	     target	= target,
	     desc	= cd,
	     loc	= desc(target),
	     save	= save)
	chunkStub(cd)
}

do.call.distObjStub <- function(what, args, save=TRUE) {
	for (arg in args) fillMetaData(arg)
	## distribute the non-distributed
	target <- findTarget(args)
	args <- lapply(args, stub, target=target)
	##
	target <- findTarget(args)
	cs <- lapply(chunkStub(target), 
		     function(t) do.call.chunkStub(what, args, t, save))
	distObjStub(cs)
}

is.AsIs <- function(x) inherits(x, "AsIs")
unAsIs <- function(x) {
	class(x) <- class(x)[!class(x) == "AsIs"]
	x
}
