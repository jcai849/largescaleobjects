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
					    target(request),
					    get0(mask(request))), 
				   error =  identity)
		if (store(request))
			addChunk(largeScaleR::desc(request), result)
	}
}

evaluate <- function(fun, args, target, mask) {
	stopifnot(is.list(args))
	args <- rapply(args, emerge, 
		       classes = c("AsIs", "chunkRef", "distObjRef"),
		       deflt = NULL, how="replace", target=target)
	fun <- getFun(fun)
	if (!missing(mask)) fun <- maskFun(fun, mask)
	do.call(fun, args, envir=.GlobalEnv)
}

getFun.function <- identity

getFun.character <- function(x) {
		funsplit <- strsplit(x, "::", fixed=TRUE)[[1]]
		if (length(funsplit) == 2L) {
			getFromNamespace(funsplit[2], funsplit[1])
		} else get(x)
}

maskFun <- function(fun, mask) {
	environment(fun) <- new.env(parent = environment(fun))
	for (m in names(mask))
		assign(m, mask[[m]], environment(fun))
	fun
}

makeCallFun <- function(f, which=0) {
	fun <- function(...) {}
	body(out) <- call("quote", f(which))
	out
}
