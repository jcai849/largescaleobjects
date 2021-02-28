kill <- function(procdesc) {
	procChunk <- structure(new.env(), class="chunkStub")
	desc(procChunk) <- paste0("process/", procdesc)
	do.call.chunkStub("q", list(save="no"), procChunk)
	invisible(NULL)
}

clearComms <- function() 
	rediscc::redis.rm(getCommsConn(),
			  rediscc::redis.keys(getCommsConn(), "*"))

.Last <- function() {
	procs <- rediscc::redis.get(getCommsConn(), "process")
	for (proc in procs)
		kill(proc)
	clearComms()
}
