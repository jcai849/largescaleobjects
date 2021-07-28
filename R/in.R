read.dlcsv <- function(host, file,
		       header=FALSE, sep=",", quote="\"", dec = ".",
		       fill=TRUE, comment.char="", col.names, colClasses) {
	dfile <- dref(mapply(distribute, arg=file, target=lapply(host, cref),
				   SIMPLIFY=FALSE, USE.NAMES=FALSE))
	do.dcall("read.csv", 
		 list(file=dfile, header=I(header), sep=I(sep), quote=I(quote),
		      dec=I(dec), fill=I(fill), comment.char=I(comment.char),
		      col.names=I(col.names), colClasses=I(colClasses)))
}

read.dcsv <- function(file, header=FALSE, sep=",", quote="\"", dec = ".",
		      fill=TRUE, comment.char="", col.names, colClasses) {
	dref(mapply(function(file, header, sep, quote, dec, fill,
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
	crefs <- list()
	cr <- iotools::chunk.reader(file, max.line=max.line)
	if (header && 
	    length(ck <- iotools::read.chunk(cr, max.size=max.size))){
		cr <- do.ccall("iotools::dstrsplit",
					       list(x=ck,
						    col_types=colTypes,
						    sep=",", nsep=NA,
						    strict=strict, skip=1,
						    quote=quote),
					     root()) 
		crefs <- c(crefs, cr)
	}
	while(length(ck <- iotools::read.chunk(cr, max.size=max.size))) {
		ck <- do.ccall("iotools::dstrsplit",
					       list(x=ck,
						    col_types=colTypes,
						    sep=",", nsep=NA,
						    strict=strict, skip=0,
						    quote=quote),
					     root()) 
		crefs <- c(crefs, cr)
	}
	dref(crefs)
}
