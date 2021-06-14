worker <- function(comms, log, host, port, prepop) {

	library("largeScaleR")

	commsProcess(largeScaleR::host(comms), largeScaleR::port(comms),
		     user(comms), pass(comms), dbpass(comms), FALSE)
	logProcess(largeScaleR::host(log), largeScaleR::port(log), FALSE)
	userProcess(host, if (missing(port)) largeScaleR::port() else port)
	init()

	assign(host(getUserProcess()), host(getUserProcess()),
	       envir=.largeScaleRKeys)
	if (!missing(prepop)) mapply(addChunk, names(prepop), prepop)

	repeat {
		keys <- c(ls(.largeScaleRChunks), ls(.largeScaleRKeys))
		request <- receive(keys)
		stateLog(paste("WRK", desc(getUserProcess()),
			       desc(request))) # WRK X Y - Working at worker X on chunk Y
		result <- tryCatch(evaluate(fun(request), 
					    args(request),
					    target(request)), 
				   error =  identity)
		if (store(request))
			addChunk(largeScaleR::desc(request), result)
	}
}

evaluate <- function(fun, args, target) {
	stopifnot(is.list(args))
	args <- rapply(args, emerge, 
		       classes = c("AsIs", "chunkRef", "distObjRef"),
		       deflt = NULL, how="replace", target=target)
	if (is.character(fun)) {
		funsplit <- strsplit(fun, "::", fixed=TRUE)[[1]]
		if (length(funsplit) == 2L)
			fun <- getFromNamespace(funsplit[2], funsplit[1])
	}
	do.call(fun, args, envir=.GlobalEnv)
}

do.NEAcall <- function(what, args) {
	stopifnot(is.character(what),
		  all(names(args) != ""))
	funsplit <- strsplit(what, "::", fixed=TRUE)[[1]]
	fun <- if (length(funsplit) == 2L) {
		call("::", as.symbol(funsplit[1]), as.symbol(funsplit[2]))
	} else as.symbol(what)
	eval(as.call(c(fun, structure(lapply(names(args), as.symbol),
				      names=names(args)))),
	     envir=args)
}

dlm <- function(formula, data, weights=NULL, sandwich=FALSE) {
	stopifnot(is.distObjRef(data))
	stopifnot(length(chunkRef(distObjRef)) > 0L)
	init <- dbiglm(formula, data, weights, sandwich)
	if (length(chunkRef(distObjRef)) == 1L) return(emerge(init))
	emerge(dreduce("update", data, init))
}

dbiglm <- function(formula, data, weights=NULL, sandwich=FALSE)
	distObjRef(list(do.ccall("do.NEAcall", list(what="biglm",
						    args=list(formula=I(stripEnv(formula)),
							      data=data,
							      weights=I(stripEnv(weights)),
							      sandwich=I(sandwich))))))

stripEnv <- function(x) {
	attr(x, ".Environment") <- NULL
	x
}
