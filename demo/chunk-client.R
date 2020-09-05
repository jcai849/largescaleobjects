library(distObj)

#invisible(readline("Type <Return> to continue"))
# Initialise connections
distInit()

#invisible(readline("Type <Return> to continue"))
# Clear any previous examples
rediscc::redis.rm(conn(), c("chunkRef1", paste0("C", 1:10), paste0("J", 1:10), 
		"JOB_ID", "CHUNK_ID"))

#invisible(readline("Type <Return> to continue"))
# Create new example object
chunk1 <- structure(new.env(), class = "chunkRef")
chunkID(chunk1) <- "chunk1"
preview(chunk1) <- 1:5
resolution(chunk1) <- "RESOLVED"

#invisible(readline("Type <Return> to continue"))
cat("Value of chunk1:", format(chunk1), "\n")

#invisible(readline("Type <Return> to continue"))
x <- do.call.chunkRef(what=expm1, chunkArg=chunk1, 
		       assign=T)

#invisible(readline("Type <Return> to continue"))
cat("Value of x:", format(x), "\n")

#invisible(readline("Type <Return> to continue"))
y <- do.call.chunkRef(log1p, x, assign=T)

#invisible(readline("Type <Return> to continue"))
cat("Value of y:", format(y), "\n")
