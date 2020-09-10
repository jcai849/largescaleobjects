server <- function() repeat {
	m <- read.queue(queues())
	switch(op(m),
	       "ASSIGN"	= do.call.chunk(what=fun(m), 
				        chunkArg=chunk(m), 
					distArgs=dist(m), 
					staticArgs=static(m), 
					jID=jobID(m),
					cID=chunkID(m)),
	       "DOFUN"	= do.call.chunk(what=fun(m), 
				        chunkArg=chunk(m), 
					distArgs=dist(m), 
					staticArgs=static(m),
					jID=jobID(m)))
}
