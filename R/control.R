kill <- function(chunk) {
	do.call.chunkStub("q", list(save="no"), chunk)
	invisible(NULL)
}

clearComms <- function() 
	rediscc::redis.rm(commsConn(),
			  rediscc::redis.keys(commsConn(), "*"))

.Last <- function() {
	info("Shutting down cluster")
	workers <- ls(get("workerProcesses", .largeScaleRProcesses))
	if (length(workers)) {
		for (proc in workers)
			kill(root())
		clearComms()
	}
}
