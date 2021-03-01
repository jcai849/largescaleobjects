kill <- function(chunk) {
	ulog::ulog(paste("shutting down chunk at descriptor",
			 format(desc(chunk))))
	do.call.chunkStub("q", list(save="no"), chunk)
	return()
}

clearComms <- function() {
	ulog::ulog("clearing redis comms")
	rediscc::redis.rm(getCommsConn(),
			  rediscc::redis.keys(getCommsConn(), "*"))
}

.Last <- function() {
	workers <- as.integer(rediscc::redis.get(getCommsConn(), 
						 "process")) - 1
	for (proc in seq(workers))
		kill(root())
	clearComms()
}
