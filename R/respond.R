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
		result <- tryCatch(do.call(mask(fun(request), mask(request)), 
					    args(request, target(request)))
				   error =  identity)
		if (store(request))
			addChunk(largeScaleR::desc(request), result)
	}
}

mask.function <- function(fun, mask) {
	if (is.null(mask)) return(fun)
	environment(fun) <- new.env(parent = environment(fun))
	for (m in names(mask))
		assign(m, as.function(mask[[m]]), environment(fun))
	fun
}
