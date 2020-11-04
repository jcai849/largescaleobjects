getLocal <- function(loc) function(field) get(field, environment(loc))
envGet <- function(field) function(x) get(field, x)
envSet <- function(field) function(x, value) {
	assign(field, value, x)
	x
}

isA <- function(class) function(x) inherits(x, class)

is.distributed <- function(x) is.distObjRef(x) | is.chunkRef(x)
is.AsIs <- isA("AsIs")

unAsIs <- function(x) {
	class(x) <- class(x)[!class(x) == "AsIs"]
	x
}

info <- function(...) {
	if (verbose()) {
		op <- options(digits.secs = 6)
		cat(c(if (!is.null(myNode())) c("[", myNode(), "]") else NULL,
		      format(Sys.time(), "%H:%M:%OS6")), " ")
		for (item in list(...)) {
			if (is.vector(item) && length(item) == 1) {
				cat(" ", format(item))
			} else {cat("\n"); print(item)}
		}
		cat("\n")
		options(op)
	}
}

combine.default 	<- c
combine.data.frame 	<- rbind
combine.matrix	 	<- rbind
combine.table <- function(...) {
	tabs <- list(...)
	chunknames <- lapply(tabs, dimnames)
	stopifnot(all(lengths(chunknames) == length(chunknames[[1]])))
	groupedvarnames <- lapply(seq(length(chunknames[[1]])),
			      function(i) lapply(chunknames,
						 function(chunk) chunk[[i]]))
	wholenames <- structure(lapply(groupedvarnames,
		       function(names) sort(unique(do.call(c, names)))),
			  names = names(chunknames[[1]]))
	wholearray <- array(0L, dim = lengths(wholenames, use.names = FALSE),
			    dimnames = wholenames)
	lapply(seq(length(tabs)), function(i)
	       {eval(substitute(wholearray_sub <<- wholearray_sub + tab_chunk, 
		   list(wholearray_sub =  do.call(call, c(list("["),
			x = quote(quote(wholearray)),
			unname(chunknames[[i]]))),
			tab_chunk = substitute(tabs[[i]], list(i = i)))))
	NULL})
	as.table(wholearray)
}
size.default 		<- length
size.data.frame 	<- nrow
size.matrix	 	<- nrow

resolve.default <- function(x, ...) identity

killAt <- function(x)
	do.call.distObjRef(function(x) q("no"), list(x=x))

# Testing

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
	chunkID(ck)	<- structure(name, class="chunkID")
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

clear <- function() rediscc::redis.rm(conn(), c(paste0("chunk", 1:20),
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
