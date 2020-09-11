server <- function() repeat {
	m <- read.queue(queues())
	a <- toAssign(m)
	v <- tryCatch({
			res <- do.call.msg(what=fun(m), 
					   args = args(m),
					   target = m,
					   assign = a)
			if (a) {
				send(RESOLUTION = "RESOLVED", 
				     PREVIEW = preview(res),
				     to = postJobID(m))
			} else {
				send(RESOLUTION = res, to = postJobID(m))
			} 
			res},
			error = function(e) {
				info("Error occurred: ", format(e$message))
				send(RESOLUTION = "ERROR", PREVIEW = e, 
				     to = postJobID(m))
				e})
	if (a) addChunk(postChunkID(m), v)
}
