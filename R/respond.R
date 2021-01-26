read <- function() {
	keys <- c(ls(.largeScaleRChunks), ls(.largeScaleRKeys))
	info("Awaiting message on queues:", format(keys))
	while (is.null(serializedMsg <-rediscc::redis.pop(commConn(), keys,
							  timeout=10))) {}
	if (clear) rediscc::redis.rm(commConn(), keys)
	request <- unserialize(charToRaw(serializedMsg))
	info("Received message:", format(m))
	request
}

evaluate <- function(fun, args, target, cd) {
	stopifnot(is.list(args))
	args <- lapply(args, unstub, target=target)
	info("Requested to perform function", format(fun),
	     "using chunk", format(desc(target)), 
	     "as target, and assigning to chunk ID", cd)
	chunk <- do.call(fun, args)
}

respond <- function(cd, chunk) {
	post(cd, chunk)
	interest <- checkInterest(cd)
	respondInterest(cd, interest)
}

post <- function(cd, chunk) {
	keys <- list(PREVIEW 	= preview(chunk),
		     SIZE 	= size(chunk),
		     HOST	= Sys.info()["nodename"],
		     PORT	= get("objPort", envir = .largeScaleRConn))
	rediscc::redis.set(commConn(), keys, list=TRUE)
}

checkInterest <- function(cd) {}
respondInterest <- function(cd, interest) {}
