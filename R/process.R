process <- function(host=Sys.info()["nodename"], port=port(), user=NULL, pass=NULL) {
	x <- list()
	class(x) <- "process"
	host(x) <- host
	port(x) <- port
	user(x) <- user
	pass(x) <- pass
	x
}

logProcess <- function(host=Sys.info()["nodename"], port=514L, init=FALSE) {
	if (init) {
		system2("ssh",  c(host, "ulogd", "-u", port))
	}
	ulog.init(path=paste0("tcp://", host, ":", port))
	x <- process(host, port)
	class(x) <- "logProcess"
	assign("logProcess", x, envir=.largeScaleRProcesses)
}

commsProcess <- function(host=Sys.info()["nodename"], port=6379L, user=NULL,
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
	desc(x) <- "comms"
	dbpass(x) <- dbpass
	assign("commsProcess", x, envir=.largeScaleRProcesses)
}

userProcess <- function(host=Sys.info()["nodename"], port=largeScaleR::port(),
			desc=largeScaleR::desc("process"), verbose=TRUE) {
	assign("verbose", verbose, envir=.largeScaleRConfig)

	x <- process(host=host, port=port)
	class(x) <- c("userProcess", class(x))

	info("Attaining process descriptor")
	desc(x) <- desc

	info("Starting osrv server")
	osrv::start(port=port)

	assign(paste0("/process/", as.character(largeScaleR::desc(x))),
	       NULL, envir=.largeScaleRKeys)
	assign(paste0("/host/", host(x)),
	       NULL, envir=.largeScaleRKeys)

	assign("userProcess", x, envir=.largeScaleRProcesses)
}

workerProcess <- function(host=Sys.info()["nodename"],
			  port=largeScaleR::port(),
			  desc=largeScaleR::desc("process"), user=NULL,
			  pass=NULL, stopOnError=FALSE, verbose=TRUE) {
	x <- process(host, port, user, pass)
	class(x) <- c("workerProcess", class(x))

	info("Attaining process descriptor")
	desc(x) <- desc

	loc <- paste0(if (!is.null(user)) paste0(user, '@') else  NULL, host)
	command <- c("R", "-e", 
		     paste0("largeScaleR::worker(comms=", 
			    deparse1(get("commsProcess", 
					envir=.largeScaleRProcesses)), 
			    ",log=",deparse1(get("logProcess", 
					envir=.largeScaleRProcesses)), 
			    ",host=", deparse1(host),
			    ",port=", deparse1(port),
			    ",desc=", deparse1(desc),
			    ",stopOnError=", deparse1(stopOnError),
			    ",verbose=", deparse1(verbose),
			    ")"))
	system2("ssh", c(loc, shQuote(shQuote(command))), 
		stdout=FALSE, stderr=FALSE,  wait=FALSE)

	assign(as.character(largeScaleR::desc(x)), x,
	       envir=get("workerProcesses", envir=.largeScaleRProcesses))
}

print.process <- function(x) {
	print(paste("largeScaleR communications process at host",
		    host(x), "and port", port(x), "under descriptor", desc(x)))
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
