# Generics and setters

do.call.chunk <- function(what, chunkArg, distArgs, staticArgs, cID) {
	if (!missing(cID)) {
		v <- do.call(what, list(chunkArg))
		cat("Assigning value", format(v), "to identifier", 
		    format(cID), "\n")
		assign(cID, v, envir = .GlobalEnv)
		assign("QUEUE", c(QUEUE, cID), envir = .GlobalEnv)
		return("RESOLVED")
	} else do.call(what, list(chunkArg))
}

chunkRef <- function(x, ...) UseMethod("chunkRef", x)
chunkRef.chunkID <- function(x, jID)  {
	cr <- new.env()
	class(cr) <- "chunkRef"
	chunkID(cr) <- x
	jobID(cr) <- jID
	resolution(cr) <- "UNRESOLVED"
	cr
}

chunkID <- function(x, ...) {
	if (missing(x)) {
		cID <- paste0("C", rediscc::redis.inc(conn(), "CHUNK_ID"))
		class(cID) <- "chunkID"
		return(cID)
	}
	UseMethod("chunkID", x)
}

`chunkID<-` <- function(x, value) UseMethod("chunkID<-", x)

`chunkID<-.chunkRef` <- function(x, value) {
	assign("CHUNK_ID", value, x)
	x
}

jobID <- function(x, ...) {
	if (missing(x)) {
		jID <- paste0("J", rediscc::redis.inc(conn(), "JOB_ID"))
		class(jID) <- "jobID"
		return(jID)
	}
	UseMethod("jobID", x)
}

`jobID<-` <- function(x, value) UseMethod("jobID<-", x)
`jobID<-.chunkRef` <- function(x, value) {
	assign("JOB_ID", value, x)
	x
}

chunk <- function(x, ...) UseMethod("chunk", x)

dist <- function(x, ...) UseMethod("dist", x)
dist.default <- stats::dist

# Initialisation

init <- local({
	rsc <- NULL

	distInit <- function(queueHost="localhost", queuePort=6379L, ...) {
		# Place for starting up worker nodes
		rsc <<- rediscc::redis.connect(queueHost, queuePort)
	}

	conn <- function() {
		if (is.null(rsc)) 
			stop("Redis connection not found. Use `distInit` to initialise.")
		rsc
	}
})

distInit <- get("distInit", environment(init))
conn <- get("conn", environment(init))
