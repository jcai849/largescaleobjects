process <- function(host=Sys.info()["nodename"], port=port(), user=NULL, pass=NULL) {
	x <- list(host=host, user=user, pass=pass)
	class(x) <- "process"
	info("Attaining process descriptor")
	desc(x) <- desc("process")
	x
}

commsProcess <- function(host=Sys.info()["nodename"], port=6379, user=NULL,
			 pass=NULL, dbpass=NULL, init=FALSE, verbose=TRUE) {
	tryCatch(get("verbose", envir=.largeScaleRConfig), error = function(e)
		 assign("verbose", verbose, envir=.largeScaleRConfig))

	if (init)
		system2("redis-server", wait=FALSE)

	info("Connecting to Redis server")
	rsc <- rediscc::redis.connect(host, port,
				      reconnect = TRUE, 
				      password=dbpass)
	assign("commsConn", rsc, envir=.largeScaleRConn)

	x <- process(host, port, user, pass)
	class(x) <- c("commsProcess", class(x))
	port(x) <- port
	dbpass(x) <- dbpass
	assign("commsProcess", x, envir=.largeScaleRProcesses)
}

userProcess <- function(port=largeScaleR::port(), verbose=TRUE) {
	assign("verbose", verbose, envir=.largeScaleRConfig)

	x <- process(port=port)
	class(x) <- c("userProcess", class(x))

	info("Starting osrv server")
	osrv::start(port=port)

	assign(paste0("/process/", as.character(desc(x))),
	       NULL, envir=.largeScaleRKeys)
	assign(paste0("/host/", host(x)),
	       NULL, envir=.largeScaleRKeys)

	assign("userProcess", x, envir=.largeScaleRProcesses)
}

workerProcess <- function(host=Sys.info()["nodename"],
			  port=largeScaleR::port(), user=NULL, pass=NULL,
			  stopOnError=FALSE, verbose=TRUE) {
	x <- process(host, port, user, pass)
	class(x) <- c("workerProcess", class(x))

	loc <- paste0(if (!is.null(user)) paste0(user, '@') else  NULL, host)
	command <- c("R", "-e", 
		     paste0("largeScaleR::worker(comms=", 
			    deparse1(get("commsProcess", 
					envir=.largeScaleRProcesses)), 
			    ",port=", deparse1(port),
			    ",stopOnError=", deparse1(stopOnError),
			    ",verbose=", deparse1(verbose),
			    ")"))
	system2("ssh", c(loc, shQuote(shQuote(command))))

	assign(as.character(desc(x)), x,
	       envir=get("workerProcesses", envir=.largeScaleRProcesses))
}

worker <- function(comms, port, stopOnError, verbose) {

	library("largeScaleR")

	commsProcess(host(comms), largeScaleR::port(comms), user(comms),
		     pass(comms), dbpass(comms), FALSE, verbose)
	userProcess(port, verbose)
	repeat {
		keys <- queue(c(ls(.largeScaleRChunks), ls(.largeScaleRKeys)))
		request <- read(keys)
		result <- tryCatch(evaluate(fun(request), args(request),
					    target(request), desc(request)), 
				   error = if (stopOnError) stop(e) else identity)
		addChunk(desc(request), result)
		respond(desc(request), result)
	}
}

print.process <- function(x) {
	print(paste("largeScaleR communications process at host",
		    host(x), "and port", port(x)))
	if (!is.null(user(x)))
		 print(paste("At user", user(x)))
}

host.process <- function(x) x$host
user.process <- function(x) x$user
pass.process <- function(x) x$pass
port.process <- function(x) x$port
desc.process <- function(x) x$desc
dbpass.commsProcess <- function(x) x$dbpass

`host<-.process` <- function(x, value) { x$host <- value; x }
`user<-.process` <- function(x, value) { x$user <- value; x }
`pass<-.process` <- function(x, value) { x$pass <- value; x }
`port<-.process` <- function(x, value) { x$port <- value; x}
`desc<-.process` <- function(x, value) { x$desc <- value; x}
`dbpass<-.commsProcess` <- function(x, value) { x$dbpass <- value; x}
