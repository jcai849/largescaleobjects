worker <- function(comms, log, host, port) {

	library("largeScaleR")

	commsProcess(largeScaleR::host(comms), largeScaleR::port(comms),
		     user(comms), pass(comms), dbpass(comms), FALSE)
	logProcess(largeScaleR::host(log), largeScaleR::port(log), FALSE)
	userProcess(host, if (missing(port)) largeScaleR::port() else port)
	init()

	repeat {
		keys <- c(ls(.largeScaleRChunks), ls(.largeScaleRKeys))
		request <- receive(keys)
		result <- tryCatch(evaluate(fun(request), args(request),
					    target(request),
					    largeScaleR::desc(request)), 
				   error =  identity)
		if (save(request))
			addChunk(largeScaleR::desc(request), result)
	}
}

evaluate <- function(fun, args, target, cd) {
	stopifnot(is.list(args))
	args <- lapply(args, unstub, target=target)
	log(paste("evaluating", paste(format(fun), collapse="\n")))
	do.call(fun, args, envir=.GlobalEnv)
}
