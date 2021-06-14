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
	args <- lapply(args, emerge, target=target)
	if (is.character(fun)) {
		funsplit <- strsplit(fun, "::", fixed=TRUE)[[1]]
		if (length(funsplit) == 2L)
			fun <- getFromNamespace(funsplit[2], funsplit[1])
	}
	do.call(fun, args, envir=.GlobalEnv)
}
