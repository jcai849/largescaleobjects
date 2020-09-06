#!/usr/bin/env R

library(distObj)

distInit(verbose=T)
chunk1 <- seq(10)
addChunk("chunk1", chunk1)

repeat {
	m <- read.queue(queues())
	switch(op(m),
	       "ASSIGN" = do.call.chunk(what=fun(m), 
					chunkArg=chunk(m), 
					distArgs=dist(m), 
					staticArgs=static(m), 
					jID=jobID(m),
					cID=chunkID(m)),
	       "DOFUN" = do.call.chunk(what=fun(m), 
				       chunkArg=chunk(m), 
				       distArgs=dist(m), 
				       staticArgs=static(m),
				       jID=jobID(m)))
}

