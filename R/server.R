server <- function(stopOnError=FALSE) repeat {
	m <- read.queue(localChunks())
	a <- toAssign(m)
	v <- if (stopOnError) serveCore(m, a) else
		tryCatch(serveCore(m,a),
			 error = function(e) {
				 info("Error occurred: ", format(e$message))
				 send(RESOLUTION= "ERROR", 
				      PREVIEW	= e, 
				      to	= postJobID(m))
				 e})
	if (a) addChunk(postChunkID(m), v)
}

serveCore <- function(m, a) {
	res <- do.call.msg(what		= fun(m), 
			   args		= args(m),
			   target	= target(m),
			   assign	= a,
			   pCID		= if (a) postChunkID(m) else NULL,
			   pJID		= postJobID(m))
	if (a) {
		send(RESOLUTION = "RESOLVED", 
		     PREVIEW 	= preview(res),
		     SIZE 	= size(res),
		     HOST	= host(),
		     PORT	= port(),
		     to 	= postJobID(m))
	} else {
		send(RESOLUTION	= res,
		     to		= postJobID(m))
	} 
	res
}
