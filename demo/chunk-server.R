#!/usr/bin/env R

library(distObj)

distInit()
chunk1 <- seq(10)
QUEUE <- "chunk1"

main <- function() {
	repeat {
		m <- read.queue(QUEUE)
		switch(op(m),
		       "ASSIGN" = {res <- tryCatch(do.call.chunk(what=fun(m), 
							chunkArg=chunk(m), 
							distArgs=dist(m), 
							staticArgs=static(m), 
							cID=chunkID(m)),
						   error = identity)
			           send(RESOLUTION = res, PREVIEW = preview(chunkID(m)),
					to = jobID(m))},
		       "DOFUN" = {res <- tryCatch(do.call.chunk(what=fun(m), 
						     chunkArg=chunk(m), 
						     distArgs=dist(m), 
						     staticArgs=static(m)),
					    error = identity)
			          send(RESOLUTION = res, to = chunkID(m))})
	}
}

main()
