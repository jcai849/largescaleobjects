kill <- function(procdesc) {
	procChunk <- structure(new.env(), class="chunkStub")
	desc(procChunk) <- paste0("process/", procdesc)
	do.call.chunkStub("q", list(save="no"), procChunk)
	invisible(NULL)
}

clearComms <- function() 
	rediscc::redis.rm(commsConn(),
			  rediscc::redis.keys(commsConn(), "*"))

.Last <- function() {
	info("Shutting down cluster")
	procs <- rediscc::redis.get(commsConn(), "process")
	for (proc in procs)
		kill(proc)
	clearComms()
}
