cdata <- function(x, ...) UseMethod("cdata", x)
cdata.chunk <- function(x, ...) {
	ccache

}
################################# Populate  ################################

access.chunkRef <- function(x, field) {
	tryCatch(get(field, x, inherits=FALSE), 
		 error = function(e) {
			 requestField(field, x)
			 commQueue <- paste0(field, desc(x))
			 response <- receive(commQueue)
			 fieldSym <- str2lang(field)
			 eval(substitute({
				 fieldSym(x) <- fieldSym(response)
				 fieldSym(response)},
				 list(fieldSym = fieldSym)))
		 })
}

access.distObjRef <- function(x, field, type=character) {
	chunks <- chunkRef(x)
	nChunks <- length(chunks)
	fields <- type(nChunks)
	commQueues <- character(nChunks)
	for (i in 1:nChunks) {
		chunk <- chunks[[i]]
		if (exists(field, chunk, inherits=FALSE)) {
			fields[i] <- get(field, chunk, inherits=FALSE)
		} else {
			requestField(field, chunk)
			commQueues[i] <- paste0(field, desc(chunk))
		}
	}
	if (!identical(commQueues, character(nChunks))){
		fieldSym <- str2lang(field)
		for (i in 1:nChunks) {
			if (!identical(commQueues[i], character(1))) {
				response <- receive(commQueues[i])
				eval(substitute({
					fields[[i]] <- fieldSym(response)
					fieldSym(chunks[[i]]) <- fields[[i]]
				}, list(fieldSym = fieldSym)))
			}
		}
	}
	fields
}

requestField.chunkRef <- function(field, x, ...) {
	commQueue <- paste0(field, desc(x))
	fieldSym <- str2lang(field)
	request <- substitute(
			do.ccall(what=function(x)
					  send(fieldSym=fieldSym(x), 
					       loc=commQueue),
					  args=list(x=x),
					  target=x,
					  store=FALSE),
			list(fieldSym = fieldSym,
			     commQueue = commQueue))
	names(request$what[[3]])[2] <- field # parse tree hack
	eval(request)
	commQueue
}

fillMetaData.distObjRef <- function(x, ...) 
	{size(x); to(x); from(x); host(x); port(x); x}
fillMetaData.default <- function(x, ...) NULL

################################# Get  ################################

distObjDo <- function(fun, rtype) function(x, ...) vapply(chunkRef(x), fun, rtype(1))

desc.chunkRef		<- function(x, ...) access(x, "desc")
desc.distObjRef	<- distObjDo(desc, integer)
from.chunkRef 		<- function(x, ...) get("from", x, inherits=FALSE)
from.distObjRef 	<- function(x, ...)
	tryCatch(sapply(chunkRef(x), function(chunk) from(chunk)),
		 error = function(e) {
			 from(x) <- c(1L, to(x)[-length(to(x))] + 1L)
			 from(x)
		 })
host.chunkRef		<- function(x, ...) access(x, "host")
host.default 		<- function(x, ...) host(getUserProcess())
host.distObjRef 	<- function(x, ...) access(x, "host", type=character)
port.chunkRef		<- function(x, ...) access(x, "port")
port.default 		<- function(x, ...) port(getUserProcess())
port.distObjRef		<- function(x, ...) access(x, "port", type=integer)
preview.chunkRef	<- function(x, ...) access(x, "preview")
preview.distObjRef	<- function(x, ...) access(chunkRef(x)[[1]], "preview")
size.chunkRef 		<- function(x, ...) access(x, "size")
size.distObjRef 	<- function(x, ...) access(x, "size", type=integer)
to.chunkRef 		<- function(x, ...) get("to", x, inherits=FALSE)
to.distObjRef		<- function(x, ...) 
	tryCatch(sapply(chunkRef(x), function(chunk) to(chunk)),
		 error = function(e) {
			 to(x) <- cumsum(size(x))
			 to(x)
		 })

################################# Set ################################

distObjSet <- function(fun) function(x, value) {
	mapply(fun, chunkRef(x), value)
	x
}

envSet <- function(field) function(x, value)
	{assign(field, value, x); x}

`chunkRef<-.distObjRef`<- function(x, value) {assign("chunk", value, x); x}
`desc<-.chunkRef`	<- envSet("desc")
`desc<-.distObjRef`	<- distObjSet(`desc<-`)
`from<-.chunkRef`	<- envSet("from")
`from<-.distObjRef`	<- distObjSet(`from<-`)
`host<-.chunkRef` 	<- envSet("host")
`host<-.distObjRef`	<- distObjSet(`host<-`)
`port<-.chunkRef` 	<- envSet("port")
`port<-.distObjRef`	<- distObjSet(`port<-`)
`preview<-.chunkRef` 	<- envSet("preview")
`preview<-.distObjRef`	<- distObjSet(`preview<-`)
`size<-.chunkRef` 	<- envSet("size")
`size<-.distObjRef`	<- distObjSet(`size<-`)
`to<-.chunkRef` 	<- envSet("to")
`to<-.distObjRef`	<- distObjSet(`to<-`)
