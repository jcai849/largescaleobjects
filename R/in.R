localCSV <- function(loc) {
	x <- list()
	class(x) <- "localCSV"
	loc(x) <- loc
	x
}

read.localCSV <- function(x, col_types, max.line=65536L, max.size=33554432L,
			  strict=TRUE, skip=0L, nrows=-1L, quote="") {
	chunkStubs <- list()
	cr <- iotools::chunk.reader(loc(x), max.line=max.line)
	while(length(chunk <- iotools::read.chunk(cr, max.size=max.size))) {
		chunkStub <- do.call.chunkStub(iotools::dstrsplit,
					       list(x=chunk,
						    col_types=col_types,
						    sep=",", nsep=NA,
						    strict=strict, skip=skip,
						    nrows=nrows, quote=quote),
					       root()) 
		chunkStubs <- c(chunkStubs, chunkStub)
	}
	distObjStub(chunkStubs)
}

loc.localCSV <- function(x) x$loc
`loc<-.localCSV` <- function(x, value) {x$loc <- value; x}
print.localCSV <- function(x) cat("localCSV at file location", loc(x))
format.localCSV <- function(x) paste("localCSV at file location", loc(x))
