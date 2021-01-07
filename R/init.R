proc <- function(host, user, pass) {

	class(x) <- "proc"
	x
}

commProc <- function(host, port, user, pass) {

	class(x) <- c("commProc", class(x))
	x
}

opProc <- function(host, user, pass) {

	class(x) <- c("opProc", class(x))
	x
}

init <- generic..

# read from config file
init.default <- function(x) {
	# parse config file as describing a commProc or opProc object
	# run init with commProc or opProc object
}

# setup communication process (start redis-server)
init.commProc <- function(x) {
}

# startup operator processes (possibly remotely)
init.opProc <- function(x, commProc, verbose) {
	# ssh if host(x) != "localhost", then call this function again with localhost as host
	info("Connecting to Redis server")
	rsc <- rediscc::redis.connect(host(x), port(x), user(x), pass(x),
				       reconnect = TRUE)
	info("Starting osrv server")
	osrv::start(port=port())

	store(rsc, .largeScaleRConn)
	store(verbose, .largeScaleRConfig)
}

