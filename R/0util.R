getLocal <- function(loc) function(field) get(field, environment(loc))
envGet <- function(field) function(x) get(field, x)
envSet <- function(field) function(x, value) {
	assign(field, value, x)
	x
}

isA <- function(class) function(x) inherits(x, class)

is.AsIs <- isA("AsIs")

unAsIs <- function(x) {
	class(x) <- class(x)[!class(x) == "AsIs"]
	x
}

info <- function(...) {
	op <- options(digits.secs = 6)
	if (verbose()) do.call(cat, c(if (!is.null(myNode()))
				      c("[",myNode(),"]") else NULL,
				      format(Sys.time(), "%H:%M:%OS6"),
				      list(...), "\n"))
	options(op)
}

combine.default 	<- c
combine.data.frame 	<- rbind
combine.matrix	 	<- rbind
size.default 		<- length
size.data.frame 	<- nrow
size.matrix	 	<- nrow

# Testing

addTestChunk <- function(name, contents) {
	ck <- makeTestChunk(name, contents)
	addChunk(name, contents)
	ck
}

makeDistObj <- function(chunkList) {
	dO <- structure(new.env(), class = "distObjRef")
	chunk(dO) <- chunkList
	dO
}

makeTestChunk <- function(name, contents, 
			  host=Sys.info()["nodename"], port=integer(),
			  from, to) {
	ck		<- structure(new.env(), class = "chunkRef")
	chunkID(ck)	<- structure(name, class="chunkID")
	jobID(ck)	<- if (connected()) jobID() else NULL
	preview(ck)	<- contents
	from(ck)	<- if (missing(from)) contents[1] else from
	to(ck)		<- if (missing(to)) contents[length(contents)] else to
	size(ck)	<- length(contents)
	resolution(ck)	<- "RESOLVED"
	host(ck) 	<- host
	port(ck) 	<- port
	ck
}

clear <- function() rediscc::redis.rm(conn(), c(paste0("chunk", 1:20),
						  paste0("C", 1:1000),
						  paste0("J", 1:1000),
						  "JOB_ID", "CHUNK_ID"))
