server <- function(stopOnError=FALSE) repeat {
	m <- read.queue(localChunks())
	v <- if (stopOnError) serveCore(m) else
		tryCatch(serveCore(m),
			 error = function(e) {
				 print(e)
				 send(RESOLUTION= "ERROR", 
				      PREVIEW	= "Error. See frame dump on node", 
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
