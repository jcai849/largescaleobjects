addTestChunk <- function(name, contents) {
	ck <- makeTestChunk(name, contents)
	addChunk(name, contents)
	ck
}

makeDistObj <- function(chunkList) {
	dO 		<- structure(new.env(), class = "distObjRef")
	chunk(dO) 	<- chunkList
	resolution(dO)  <- "RESOLVED"
	dO
}

makeTestChunk <- function(name, contents, 
			  host=Sys.info()["nodename"], port=integer(),
			  from, to) {
	ck		<- structure(new.env(), class = "chunkRef")
	chunkDesc(ck)	<- structure(name, class="chunkDesc")
	jobID(ck)	<- if (connected()) jobID() else NULL
	preview(ck)	<- contents
	from(ck)	<- if (missing(from)) contents[1] else from
	to(ck)		<- if (missing(to)) contents[length(contents)] else to
	size(ck)	<- size(contents)
	resolution(ck)	<- "RESOLVED"
	host(ck) 	<- host
	port(ck) 	<- port
	ck
}

clear <- function() rediscc::redis.rm(commConn(), c(paste0("chunk", 1:20),
						  paste0("C", 1:1000),
						  paste0("J", 1:1000),
						  "JOB_ID", "CHUNK_ID"))

index <- function(x, i) {
	ndim <- if (is.null(dim(x))) 1L else length(dim(x))
	l <- as.list(quote(x[]))[3]
	eval(as.call(
		     c(list(quote(`[`)), 
		       list(quote(x)),
		       list(quote(i)),
		       rep(l, ndim-1L))
		     ))
}
