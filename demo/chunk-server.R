#!/usr/bin/env R

library(distObj)

distInit(verbose=T)
chunk1 <- seq(10)
addChunk("chunk1", chunk1)

repeat {
	m <- read.queue(queues())
	switch(op(m),
	       "ASSIGN" = tryCatch({
		       res <- do.call.chunk(what=fun(m), 
					    chunkArg=chunk(m), 
					    distArgs=dist(m), 
					    staticArgs=static(m), 
					    cID=chunkID(m))
		       send(RESOLUTION = res, PREVIEW = preview(chunkID(m)),
			    to = jobID(m))
	       },
	       error = function(e) send(RESOLUTION = e, 
					to=jobID(m))),
	       "DOFUN" = tryCatch({
		       res <- do.call.chunk(what=fun(m), 
					    chunkArg=chunk(m), 
					    distArgs=dist(m), 
					    staticArgs=static(m))
		       send(RESOLUTION = res, to = jobID(m))
	       },
	       error = function(e) send(RESOLUTION = e, to=jobID(m))))
}

