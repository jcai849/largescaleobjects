read <- function(stopOnError=FALSE) repeat {
	request <- readQueue(c(ls(.largeScaleRChunks), 
			       ls(.largeScaleRKeys)))
	if (stopOnError) evaluate(request) else
		tryCatch(evaluate(request),
			 error = function(e) 
			 {
				 print(e)
				 addChunk(desc(request), e)
				 respond(exit = e)
				 NULL
			 })
}

evaluate <- function(request) {
	chunk <- do.call.request(what		= fun(request), 
				 args		= args(request),
				 target		= target(request),
				 chunkDesc	= desc(request))
	addChunk(desc(request), chunk)
	respond(PREVIEW 	= preview(chunk),
		SIZE 		= size(chunk),
		HOST		= Sys.info()["nodename"],
		PORT		= get("objPort", envir = .largeScaleRConn))
	NULL
}

do.call.request <- function(what, args, target, chunk_desc) {
	stopifnot(is.list(args))
	args <- lapply(args, unmarshall, target=target)
	info("Requested to perform function", format(what),
	     "using chunk", format(desc(target)), 
	     "as target, and assigning to chunk ID", chunk_desc)
	do.call(what, args)
}

readQueue <- function(keys, clear = FALSE) {
	info("Awaiting message on queues:", format(keys))
	while (is.null(serializedMsg <-rediscc::redis.pop(commConn(), keys,
							  timeout=10))) {}
	if (clear) rediscc::redis.rm(commConn(), keys)
	m <- unserialize(charToRaw(serializedMsg))
	info("Received message:", format(m))
	m
}
