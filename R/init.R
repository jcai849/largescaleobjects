proc <- function(host="localhost", user=NULL, pass=NULL) {
	x <- list(host=host, user=user, pass=pass)
	class(x) <- "proc"
	x
}

commProc <- function(host="localhost", port=6379,
		     user=NULL, pass=NULL, dbpass=NULL) {
	x <- proc(host, user, pass)
	class(x) <- c("commProc", class(x))
	port(x) <- port
	dbpass(x) <- dbpass
	x
}

opProc <- function(host="localhost", user=NULL, pass=NULL) {
	x <- proc(host, user, pass)
	class(x) <- c("opProc", class(x))
	x
}

print.proc <- function(x) {
	print(paste("Model of largeScaleR process at host", host(x)))
	if (!is.null(user(x)))
		 print(paste("At user", user(x)))
}

print.commProc <- function(x) {
	print(paste("Model of largeScaleR communications process at host", host(x), "and port", port(x)))
	if (!is.null(user(x)))
		 print(paste("At user", user(x)))
}

host.proc <- function(x) x$host
user.proc <- function(x) x$user
pass.proc <- function(x) x$pass
port.commProc <- function(x) x$port
dbpass.commProc <- function(x) x$dbpass

`host<-.proc` <- function(x, value) { x$host <- value; x }
`user<-.proc` <- function(x, value) { x$user <- value; x }
`pass<-.proc` <- function(x, value) { x$pass <- value; x }
`port<-.commProc` <- function(x, value) { x$port <- value; x}
`dbpass<-.commProc` <- function(x, value) { x$dbpass <- value; x}

# read from config file
init.default <- function(x) {
	# parse config file as describing a commProc or opProc object
	# run init with commProc or opProc object
}

# setup communication process (start redis-server)
init.commProc <- function(x) {
}

# startup operator processes (possibly remotely)
init.opProc <- function(x, commProc, verbose=TRUE) {
	assign("verbose", verbose,envir=.largeScaleRConfig)

	# self init
	if (host(x) == "localhost" || host(x) == Sys.info()["nodename"]) {

		info("Connecting to Redis server")
		rsc <- rediscc::redis.connect(host(commProc), port(commProc),
					      reconnect = TRUE, 
					      password=dbpass(commProc))
		assign("rsc", rsc, envir=.largeScaleRConn)

		info("Attaining process descriptor")
		procDesc <- desc("process")
		assign("procDesc", procDesc, envir=.largeScaleRConn)

		info("Starting osrv server")
		objPort <- port()
		osrv::start(port=objPort)
		assign("objPort", objPort, envir=.largeScaleRConn)

	# other init
	} else {
	# ssh and start +  serve
	}
}
