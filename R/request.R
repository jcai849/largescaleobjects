do.call.chunkStub <- function(what, args, target, store=TRUE) {
	stopifnot(is.list(args))
	cd <- desc("chunk")
	send(fun	= what, 
	     args	= args,
	     target	= target,
	     desc	= cd,
	     loc	= desc(target),
	     store	= store)
	chunkStub(cd)
}

do.call.distObjStub <- function(what, args, store=TRUE) {
	for (arg in args) fillMetaData(arg)
	## distribute the non-distributed
	target <- findTarget(args)
	args <- lapply(args, stub, target=target)
	##
	target <- findTarget(args)
	cs <- lapply(chunkStub(target), 
		     function(t) do.call.chunkStub(what, args, t, store))
	distObjStub(cs)
}

requestField.chunkStub <- function(field, x) {
	do.call.chunkStub(what=function(field, xStub)
				  send(get(field)(unstub(xStub)), 
				       paste0(field, desc(xStub))),
			  args=list(field=I(field), xStub=I(x)),
			  target=x,
			  store=FALSE)
        response <- receive(paste0(field, desc(x)))
        eval(substitute(field(x) <- response,
                   list(field=str2lang(field))))
}
