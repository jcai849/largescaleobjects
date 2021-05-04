distributedCSV <- function(files, header, col.names, colClasses, quotes="\"") {
	x <- list(host=character(length(files)),
		  path=character(length(files)),
		  col.names=character(1),
		  header=logical(1),
		  colclasses=character(1),
		  quotes=character(1))
	class(x) <- "distributedCSV"
	path(x) <- files
	host(x) <- NA_character_
	# TODO: allow files on networked machines
#	uri <- regmatches(x, regexec("^(?<host>.*?):(?<path>.*)", x, perl=T))
#	for (i in seq(length(uri))) {
#		if (length(uri[[i]]) == 3 && 
#		    !grepl("^(https?)|(ftp)$", uri[2])) {# non-internet host found
#			host(x)[i] <- uri[2]
#			path(x)[i] <- uri[3]
#		} else {
#			host(x)[i] <- NA_character_
#			path(x)[i] <- files
#		}
#	}
	colClasses(x) <- colClasses
	colNames(x) <- col.names
	header(x) <- header
	quotes(x) <- quotes
	x
}

read.distributedCSV <- function(dcsv) {
	distObjRef(mapply(function(file, header, colClasses, col.names, quotes, target) {
				  do.call.chunkRef("read.csv", 
						   args = list(file=I(file),
							       header = I(header),
							       colClasses = I(colClasses), 
							       col.names = I(col.names), 
							       quote = I(quotes)), 
						   target = root()) #TODO change for networked csv
				},
				file=path(dcsv), target=host(dcsv), 
				MoreArgs = list(header=header(dcsv),
						colClasses=colClasses(dcsv),
						col.names=colNames(dcsv), 
						quotes=quotes(dcsv)),
			  SIMPLIFY=FALSE, USE.NAMES=FALSE))
}

host.distributedCSV <- function(x, ...) x$host
path.distributedCSV <- function(x, ...) x$path
desc.distributedCSV <- host
colClasses.distributedCSV <- function(x, ...) x$colClasses
colNames.distributedCSV <- function(x, ...) x$col.names
header.distributedCSV <- function(x, ...) x$header
quotes.distributedCSV <- function(x, ...) x$quotes
`host<-.distributedCSV` <- function(x, value) {x$host <- value; x}
`path<-.distributedCSV` <- function(x, value) {x$path <- value; x}
`colClasses<-.distributedCSV` <- function(x, value) {x$colClasses <- value; x}
`colNames<-.distributedCSV` <- function(x, value) {x$col.names <- value; x}
`header<-.distributedCSV` <- function(x, value) {x$header <- value; x}
`quotes<-.distributedCSV` <- function(x, value) {x$quotes <- value; x}
print.distributedCSV <- function(x, ...) 
	cat("distributedCSV with file path", paste(path(x), collapse="; "), "\n")
format.distributedCSV <- function(x, ...) paste("distributedCSV with file location", path(x))

localCSV <- function(file, header, colTypes, quotes="") {
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
						    quote=quotes(x)),
					     root()) 
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
