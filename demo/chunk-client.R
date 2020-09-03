#!/usr/bin/env R

library(distObj)

distInit()
rediscc::redis.rm(conn(), c("distChunk1", paste0("C", 1:10), paste0("J", 1:10), 
		"JOB_ID", "CHUNK_ID"))
distChunk1 <- structure(new.env(), class = "distChunk")
chunkID(distChunk1) <- "distChunk1"

main <- function() {
	cat("Value of distChunk1:", format(distChunk1), "\n")
	x <- do.call.distChunk(what=expm1, chunkArg=distChunk1, 
			       assign=T, wait=F)
	cat("Value of x:", format(x), "\n")
	y <- do.call.distChunk(log1p, x, assign=T, wait=T)
	cat("Value of y:", format(y), "\n")
}

main()
