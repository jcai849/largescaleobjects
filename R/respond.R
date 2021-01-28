queue <- function(x) {class(x) <- "queue"; x}

read.queue <- function(x) {
	info("Awaiting message on queues:", format(x))
	while (is.null(serializedMsg <- rediscc::redis.pop(commConn(), x,
							   timeout=10))) {}
	m <- unserialize(charToRaw(serializedMsg))
	info("Received message:", format(m))
	m
}

evaluate <- function(fun, args, target, cd) {
	stopifnot(is.list(args))
	args <- lapply(args, unstub, target=target)
	info("Requested to perform function", format(fun),
	     "using chunk", format(desc(target)), 
	     "as target, and assigning to chunk ID", cd)
	chunk <- do.call(fun, args, envir=.GlobalEnv)
}

respond <- function(cd, chunk) {
	post(cd, chunk)
	interest <- checkInterest(cd)
	respondInterest(cd, interest)
}

post <- function(cd, chunk) {
	keys <- list(preview 	= preview(chunk),
		     size 	= size(chunk),
		     host	= Sys.info()["nodename"],
		     port	= get("objPort", envir = .largeScaleRConn)) 
	names(keys) <- paste0(cd, names(keys))
	rediscc::redis.set(commConn(), keys, list=TRUE)
}

checkInterest <- function(cd)
	redis.get(commsConn(), paste0("interest", cd))

respondInterest <- function(cd, interest) {
	for (i in paste0("response", seq(interest)))
		send(complete = TRUE, loc=i)
}
