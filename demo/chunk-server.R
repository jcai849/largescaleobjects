#!/usr/bin/env R

library(distObj)

distInit()
distChunk1 <- seq(10)
QUEUE <- "distChunk1"

main <- function() {
	repeat {
		m <- read.queue(QUEUE)
		switch(op(m),
		       "ASSIGN" = {cID <- do.call.chunk(what=fun(m), 
							chunkArg=chunk(m), 
							distArgs=dist(m), 
							staticArgs=static(m), 
							assign=TRUE)
			           send(CHUNK_ID = cID, to = jobID(m))},
		       "DOFUN" = {v <- do.call.chunk(what=fun(m), 
						     chunkArg=chunk(m), 
						     distArgs=dist(m), 
						     staticArgs=static(m), 
						     assign=FALSE)
			          send(VAL = v, to = jobID(m))})
	}
}

main()
