server <- function(stopOnError=FALSE) repeat {
	m <- read.queue(localChunks())
	v <- if (stopOnError) serveCore(m) else
		tryCatch(serveCore(m),
			 error = function(e) {
				 info("Error occurred: ", format(e$message))
				 send(RESOLUTION= "ERROR", 
				      PREVIEW	= e, 
				      to	= postJobID(m))
				 e})
	addChunk(postChunkID(m), v)
}

serveCore <- function(m) {
	res <- do.call.msg(what		= fun(m), 
			   args		= args(m),
			   target	= target(m),
			   pCID		= postChunkID(m),
			   pJID		= postJobID(m))
	send(RESOLUTION = "RESOLVED", 
	     PREVIEW 	= preview(res),
	     SIZE 	= size(res),
	     HOST	= host(),
	     PORT	= port(),
	     to 	= postJobID(m))
	res
}
