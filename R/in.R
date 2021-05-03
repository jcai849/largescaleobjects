distributedCSV <- function(host, file, header, colClasses, quotes) {
	x <- list()
	class(x) <- "distributedCSV"
	host(x) <- host
	file(x) <- file
	colClasses(x) <- colClasses
	header(x) <- header
	quotes(x) <- quotes
	x
}

read.distributedCSV <- function(dcsv)
	distObjRef(lapply(dcsv, function(x)
			  do.call.chunkRef("read.csv", 
					   args = list(file=I(file(x)),
						       header = I(header(x)),
						       colClasses = I(colClasses(x)), 
						       quote = I(quotes(x))), 
					   target = x)))


file.distributedCSV <- function(x, ...) x$file
host.distributedCSV <- function(x, ...) x$host
desc.distributedCSV <- host
colClasses.distributedCSV <- function(x, ...) x$colClasses
header.distributedCSV <- function(x, ...) x$header
quotes.distributedCSV <- function(x, ...) x$quotes
`file<-.distributedCSV` <- function(x, value) {x$file <- value; x}
`host<-.distributedCSV` <- function(x, value) {x$host <- value; x}
`colClasses<-.distributedCSV` <- function(x, value) {x$colClasses <- value; x}
`header<-.distributedCSV` <- function(x, value) {x$header <- value; x}
`quotes<-.distributedCSV` <- function(x, value) {x$quotes <- value; x}
print.distributedCSV <- function(x, ...) cat("distributedCSV at file location", file(x), "\n")
format.distributedCSV <- function(x, ...) paste("distributedCSV at file location", file(x))

localCSV <- function(file, header, colTypes, quotes) {
	x <- list()
	class(x) <- "localCSV"
	file(x) <- file
	colTypes(x) <- colTypes
	header(x) <- header
	quotes(x) <- quotes
	x
}

read.localCSV <- function(x, max.line=65536L, 
			  max.size=33554432L, strict=TRUE) {
	chunkRefs <- list()
	cr <- iotools::chunk.reader(file(x), max.line=max.line)
	if (header(x) && 
	    length(chunk <- iotools::read.chunk(cr, max.size=max.size))){
		chunkRef <- do.call.chunkRef(iotools::dstrsplit,
					       list(x=chunk,
						    col_types=colTypes(x),
						    sep=",", nsep=NA,
						    strict=strict, skip=1,
						    quote=quotes(x)), root()) 
		chunkRefs <- c(chunkRefs, chunkRef)
	}
	while(length(chunk <- iotools::read.chunk(cr, max.size=max.size))) {
		chunkRef <- do.call.chunkRef(iotools::dstrsplit,
					       list(x=chunk,
						    col_types=colTypes(x),
						    sep=",", nsep=NA,
						    strict=strict, skip=0,
						    quote=quotes(x)), root()) 
		chunkRefs <- c(chunkRefs, chunkRef)
	}
	distObjRef(chunkRefs)
}

file.localCSV <- function(x, ...) x$file
colTypes.localCSV <- function(x, ...) x$colTypes
header.localCSV <- function(x, ...) x$header
quotes.localCSV <- function(x, ...) x$quotes
`file<-.localCSV` <- function(x, value) {x$file <- value; x}
`colTypes<-.localCSV` <- function(x, value) {x$colTypes <- value; x}
`header<-.localCSV` <- function(x, value) {x$header <- value; x}
`quotes<-.localCSV` <- function(x, value) {x$quotes <- value; x}
print.localCSV <- function(x, ...) cat("localCSV at file location", file(x), "\n")
format.localCSV <- function(x, ...) paste("localCSV at file location", file(x))
