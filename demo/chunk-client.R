library(distObj)

invisible(readline("Type <Return> to continue"))
# Initialise connections
distInit()

invisible(readline("Type <Return> to continue"))
# Clear any previous examples
rediscc::redis.rm(conn(), c("distChunk1", paste0("C", 1:10), paste0("J", 1:10), 
		"JOB_ID", "CHUNK_ID"))

invisible(readline("Type <Return> to continue"))
# Create new example object
distChunk1 <- structure(new.env(), class = "distChunk")
chunkID(distChunk1) <- "distChunk1"

invisible(readline("Type <Return> to continue"))
cat("Value of distChunk1:", format(distChunk1), "\n")

invisible(readline("Type <Return> to continue"))
x <- do.call.distChunk(what=expm1, chunkArg=distChunk1, 
		       assign=T, wait=F)

invisible(readline("Type <Return> to continue"))
cat("Value of x:", format(x), "\n")

invisible(readline("Type <Return> to continue"))
y <- do.call.distChunk(log1p, x, assign=T, wait=T)

invisible(readline("Type <Return> to continue"))
cat("Value of y:", format(y), "\n")
