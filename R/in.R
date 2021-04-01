localCSV <- function(loc, colTypes, header, quotes) {
	x <- list()
	class(x) <- "localCSV"
	loc(x) <- loc
	colTypes(x) <- colTypes
	header(x) <- header
	quotes(x) <- quotes
	x
}

read.localCSV <- function(x, max.line=65536L, 
			  max.size=33554432L, strict=TRUE) {
	chunkStubs <- list()
	cr <- iotools::chunk.reader(loc(x), max.line=max.line)
	if (header(x) && 
	    length(chunk <- iotools::read.chunk(cr, max.size=max.size))){
		chunkStub <- do.call.chunkStub(iotools::dstrsplit,
					       list(x=chunk,
						    col_types=colTypes(x),
						    sep=",", nsep=NA,
						    strict=strict, skip=1,
						    quote=quotes(x)), root()) 
		chunkStubs <- c(chunkStubs, chunkStub)
	}
	while(length(chunk <- iotools::read.chunk(cr, max.size=max.size))) {
		chunkStub <- do.call.chunkStub(iotools::dstrsplit,
					       list(x=chunk,
						    col_types=colTypes(x),
						    sep=",", nsep=NA,
						    strict=strict, skip=0,
						    quote=quotes(x)), root()) 
		chunkStubs <- c(chunkStubs, chunkStub)
	}
	distObjStub(chunkStubs)
}

loc.localCSV <- function(x, ...) x$loc
colTypes.localCSV <- function(x, ...) x$colTypes
header.localCSV <- function(x, ...) x$header
quotes.localCSV <- function(x, ...) x$quotes
`loc<-.localCSV` <- function(x, value) {x$loc <- value; x}
`colTypes<-.localCSV` <- function(x, value) {x$colTypes <- value; x}
`header<-.localCSV` <- function(x, value) {x$header <- value; x}
`quotes<-.localCSV` <- function(x, value) {x$quotes <- value; x}
print.localCSV <- function(x, ...) cat("localCSV at file location", loc(x), "\n")
format.localCSV <- function(x, ...) paste("localCSV at file location", loc(x))
