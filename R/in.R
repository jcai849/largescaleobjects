read.localCSV <- function(x, col_types, sep="|", nsep=NA, 
			  strict=TRUE, skip=0L, nrows=-1L, quote="") {
	chunkStubs <- list()
	cr <- iotools::chunk.reader(file(x))
	while(!is.null(chunk <- iotools::read.chunk(cr))) {
		cd <- desc("chunk")
		send(fun	= iotools::dstrsplit,
		     args	= list(x=chunk, col_types=col_types, sep=sep,
					nsep=nsep, strict=strict, skip=skip,
					nrows=nrows, quote=quote),
		     target	= NULL,
		     desc	= cd,
		     loc = "/")
		chunkStubs <- c(chunkStubs, chunkStub(cd))
	}
	distObjStub(chunkStubs)
}

localCSV <- function(file) {
	x <- list()
	x$file <- file
	class(x) <- "localCSV"
	x
}
file.localCSV <- function(x) x$file
print.localCSV <- function(x) cat("localCSV at file location", file(x))
