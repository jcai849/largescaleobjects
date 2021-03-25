################################# Populate  ################################

access.chunkStub <- function(x, field, alt=requestField) {
	tryCatch(get(field, x, inherits=FALSE), 
		 error = function(e) {
			 alt(field, x)
			 commQueue <- paste0(field, desc(x))
			 response <- receive(commQueue)
			 fieldSym <- str2lang(field)
			 eval(substitute({
				 fieldSym(x) <- fieldSym(response)
				 fieldSym(response)},
				 list(fieldSym = fieldSym)))
		 })
}

access.distObjStub <- function(x, field, type=character) {
	chunks <- chunkStub(x)
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

requestField.chunkStub <- function(field, x) {
	commQueue <- paste0(field, desc(x))
	fieldSym <- str2lang(field)
	request <- substitute(
			do.call.chunkStub(what=function(x)
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

fillMetaData.distObjStub <- function(x) 
	{size(x); to(x); from(x); host(x); port(x); return()}
fillMetaData.default <- function(x) NULL

################################# Get  ################################

distObjDo <- function(fun, rtype) function(x) vapply(chunkStub(x), fun, rtype(1))

desc.chunkStub		<- function(x) access(x, "desc")
desc.distObjStub	<- distObjDo(desc, integer)
from.chunkStub 		<- function(x) access(x, "from", stop)
from.distObjStub 	<- function(x)
	tryCatch(sapply(chunkStub(x),
			function(chunk) get("from", chunk, inherits=FALSE)),
		 error = function(e) {
			 from(x) <- c(1L, to(x)[-length(to(x))] + 1L)
			 from(x)
		 })
host.chunkStub		<- function(x) access(x, "host")
host.default 		<- function(x) host(getUserProcess())
host.distObjStub 	<- function(x) access(x, "host", type=character)
port.chunkStub		<- function(x) access(x, "port")
port.default 		<- function(x) port(getUserProcess())
port.distObjStub	<- function(x) access(x, "port", type=integer)
preview.chunkStub	<- function(x) access(x, "preview")
preview.distObjStub	<- function(x) access(chunkStub(x)[[1]], "preview")
size.chunkStub 		<- function(x) access(x, "size")
size.distObjStub 	<- function(x) access(x, "size", type=integer)
to.chunkStub 		<- function(x) access(x, "to", stop)
to.distObjStub		<- function(x) 
	tryCatch(sapply(chunkStub(x),
			function(chunk) get("to", chunk, inherits=FALSE)),
		 error = function(e) {
			 to(x) <- cumsum(size(x))
			 to(x)
		 })

################################# Set ################################

distObjSet <- function(fun) function(x, value) {
	mapply(fun, chunkStub(x), value)
	x
}

envSet <- function(field) function(x, value)
	{assign(field, value, x); x}

`chunkStub<-.distObjStub`<- function(x, value) {assign("chunk", value, x); x}
`desc<-.chunkStub`	<- envSet("desc")
`desc<-.distObjStub`	<- distObjSet(`desc<-`)
`from<-.chunkStub`	<- envSet("from")
`from<-.distObjStub`	<- distObjSet(`from<-`)
`host<-.chunkStub` 	<- envSet("host")
`host<-.distObjStub`	<- distObjSet(`host<-`)
`port<-.chunkStub` 	<- envSet("port")
`port<-.distObjStub`	<- distObjSet(`port<-`)
`preview<-.chunkStub` 	<- envSet("preview")
`preview<-.distObjStub`	<- distObjSet(`preview<-`)
`size<-.chunkStub` 	<- envSet("size")
`size<-.distObjStub`	<- distObjSet(`size<-`)
`to<-.chunkStub` 	<- envSet("to")
`to<-.distObjStub`	<- distObjSet(`to<-`)
