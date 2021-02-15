kill <- function(chunk) {
	do.call.chunkStub("q", list(save="no"), chunk)
	invisible(NULL)
}

clearComms <- function() 
	rediscc::redis.rm(commsConn(),
			  rediscc::redis.keys(commsConn(), "*"))

.Last <- function() {
	info("Shutting down cluster")
	workers <- rediscc::redis.get(commsConn(), "process") - 1
	if (length(workers)) {
		for (proc in seq(workers))
			kill(root())
	}
	clearComms()
}
