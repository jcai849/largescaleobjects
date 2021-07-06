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
		result <- tryCatch(do.call(insert(fun(request), insert(request)), 
					    args(request, target(request))),
				   error =  identity)
		if (store(request))
			addChunk(largeScaleR::desc(request), result)
	}
}

insert.function <- function(fun, insert) {
	if (is.null(insert)) return(fun)
	environment(fun) <- new.env(parent = environment(fun))
	for (m in names(insert))
		assign(m, insert[[m]], environment(fun))
	fun
}
