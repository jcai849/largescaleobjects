serve <- function(stopOnError=FALSE) repeat {
	m <- read.queue(localChunks())
	if (stopOnError) evaluate(m) else
		tryCatch(evaluate(m),
		 error = function(e) {
			 print(e)
			 addChunk(postChunkID(m), e)
			 send(RESOLUTION= "ERROR", 
			      PREVIEW	= "Error. See frame dump on node",
			      to	= postJobID(m))
			 NULL})
}

evaluate <- function(m) {
	res <- do.call.msg(what		= fun(m), 
			   args		= args(m),
			   target	= target(m),
			   pCID		= postChunkID(m),
			   pJID		= postJobID(m))
	addChunk(postChunkID(m), res)
	send(RESOLUTION = "RESOLVED", 
	     PREVIEW 	= preview(res),
	     SIZE 	= size(res),
	     HOST	= host(),
	     PORT	= port(),
	     to 	= postJobID(m))
	NULL
}
