read.localCSV <- function(x, col_types, max.line=65536L, max.size=33554432L,
			  sep="|", nsep=NA, strict=TRUE, skip=0L, nrows=-1L,
			  quote="") {
	chunkStubs <- list()
	cr <- iotools::chunk.reader(loc(x), max.line=max.line)
	while(length(chunk <- iotools::read.chunk(cr, max.size=max.size))) {
		cd <- desc("chunk")
		send(fun	= "iotools::dstrsplit",
		     args	= list(x=chunk, col_types=col_types, sep=sep,
					nsep=nsep, strict=strict, skip=skip,
					nrows=nrows, quote=quote),
		     target	= NULL,
		     desc	= cd,
		     loc 	= "/")
		chunkStubs <- c(chunkStubs, chunkStub(cd))
	}
	distObjStub(chunkStubs)
}

localCSV <- function(loc) {
	x <- list()
	class(x) <- "localCSV"
	loc(x) <- loc
	x
}
loc.localCSV <- function(x) x$loc
`loc<-.localCSV` <- function(x, value) {x$loc <- value; x}
print.localCSV <- function(x) cat("localCSV at file location", loc(x))
