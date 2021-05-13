read.dlcsv <- function(host, file,
		       header=FALSE, sep=",", quote="\"", dec = ".",
		       fill=TRUE, comment.char="", col.names, colClasses) {
	dfile <- mapply(distribute, file=file, target=lapply(host, chunkRef))
	browser()
	do.dcall("read.csv", 
		 list(file=file, header=I(header), sep=I(sep), quote=I(quote),
		      dec=I(dec), fill=I(fill), comment.char=I(comment.char),
		      col.names=I(col.names), colClasses=I(colClasses)))
}

read.dcsv <- function(file, header=FALSE, sep=",", quote="\"", dec = ".",
		      fill=TRUE, comment.char="", col.names, colClasses) {
	distObjRef(mapply(function(file, header, sep, quote, dec, fill,
				   comment.char, col.names, colClasses) {
				  do.ccall("read.csv", 
						   args = list(file=I(file),
							       header=I(header),
							       sep=I(sep),
							       quote=I(quote),
							       dec=I(dec),
							       fill=I(fill),
							       comment.char=I(comment.char),
							       col.names=I(col.names),
							       colClasses=I(colClasses)), 
						   target = root())
				},
				file=file, header=header, sep=sep, quote=quote,
				dec=dec, fill=fill, comment.char=comment.char,
				col.names=col.names, colClasses=colClasses, 
				SIMPLIFY=FALSE, USE.NAMES=FALSE))
}

read.lcsv <- function(file, header, colTypes, quote="", max.line=65536L, 
			  max.size=33554432L, strict=TRUE) {
	chunkRefs <- list()
	cr <- iotools::chunk.reader(file, max.line=max.line)
	if (header && 
	    length(chunk <- iotools::read.chunk(cr, max.size=max.size))){
		chunkRef <- do.ccall(iotools::dstrsplit,
					       list(x=chunk,
						    col_types=colTypes,
						    sep=",", nsep=NA,
						    strict=strict, skip=1,
						    quote=quote),
					     root()) 
		chunkRefs <- c(chunkRefs, chunkRef)
	}
	while(length(chunk <- iotools::read.chunk(cr, max.size=max.size))) {
		chunkRef <- do.ccall(iotools::dstrsplit,
					       list(x=chunk,
						    col_types=colTypes,
						    sep=",", nsep=NA,
						    strict=strict, skip=0,
						    quote=quote),
					     root()) 
		chunkRefs <- c(chunkRefs, chunkRef)
	}
	distObjRef(chunkRefs)
}
