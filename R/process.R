process <- function(host=Sys.info()["nodename"], port=port(), user=NULL, pass=NULL) {
	x <- list(host=host, user=user, pass=pass)
	class(x) <- "process"
	info("Attaining process descriptor")
	desc(x) <- desc("process")
	x
}

commsProcess <- function(host=Sys.info()["nodename"], port=6379,
			 user=NULL, pass=NULL, dbpass=NULL, init=FALSE) {
	x <- process(host, port, user, pass)
	class(x) <- c("commsProcess", class(x))
	port(x) <- port
	dbpass(x) <- dbpass

	if (init)
		system2("redis-server", wait=FALSE)

	assign("commsProcess", x, envir=.largeScaleRProcesses)
}

userProcess <- function(port) {
	x <- process()
	class(x) <- c("userProcess", class(x))

	info("Starting osrv server")
	osrv::start(port=port(x))

	info("Connecting to Redis server")
	comms <- get("commsProcess", envir=.largeScaleRConn)
	rsc <- rediscc::redis.connect(host(comms), port(comms),
				      reconnect = TRUE, 
				      password=dbpass(comms))
	assign("rsc", commsConn, envir=.largeScaleRConn)

	assign(processDesc, NULL, envir=.largeScaleRKeys)
	assign(host(x), NULL, envir=.largeScaleRKeys)
	assign(movePort, NULL, envir=.largeScaleRKeys)

	assign("userProcess", x, envir=.largeScaleRProcesses)
}

workerProcess <- function(host=Sys.info()["nodename"], port=port(),
			  user=NULL, pass=NULL, stopOnError=FALSE) {
	x <- process(host, port, user, pass)
	class(x) <- c("workerProcess", class(x))

	loc <- paste0(ifelse(!is.null(user), paste0(user, "@"), NULL),
		      host,
		      ifelse(!is.null(port), paste0(port, ":"), NULL))
	command <- c("R -e", 
		     paste0("worker(comms=", 
			    deparse(get("commsProcess", 
					envir=.largeScaleRConn)), 
			    ',stopOnError=', deparse(stopOnError)))
	system2("ssh", shQuote(c(loc, command)))

	assign(desc(x), x, envir=get("workerProcesses", envir=.largeScaleRProcesses))
}

worker <- function(comms, stopOnError) {
	commsProcess(host(comms), port(comms), user(comms), 
		     pass(comms), dbpass(comms), FALSE)
	userProcess()
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
	print(paste("Model of largeScaleR process at host", host(x)))
	if (!is.null(user(x)))
		 print(paste("At user", user(x)))
}

print.comms <- function(x) {
	print(paste("Model of largeScaleR communications process at host",
		    host(x), "and port", port(x)))
	if (!is.null(user(x)))
		 print(paste("At user", user(x)))
}

host.process <- function(x) x$host
user.process <- function(x) x$user
pass.process <- function(x) x$pass
port.process <- function(x) x$port
dbpass.commsProcess <- function(x) x$dbpass
desc.process <- function(x) x$desc

`host<-.process` <- function(x, value) { x$host <- value; x }
`user<-.process` <- function(x, value) { x$user <- value; x }
`pass<-.process` <- function(x, value) { x$pass <- value; x }
`port<-.process` <- function(x, value) { x$port <- value; x}
`dbpass<-.commsProcess` <- function(x, value) { x$dbpass <- value; x}
`desc<-.commsProcess` <- function(x, value) { x$desc <- value; x}
