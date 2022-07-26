read.dcsv <- function(hosts, paths, header=FALSE, sep=",", quote="\"",
		      dec=".", fill=TRUE, comment.char="", col.names, colClasses) {
	chunks <- mapply(chunknet::push, paths, hosts,
			 SIMPLIFY=FALSE, USE.NAMES=FALSE)
	do.dcall(read.csv,
		 list(file=DistributedObject(chunks),
		      header=header,
		      sep=sep,
		      quote=quote,
		      dec=dec,
		      fill=fill,
		      comment.char=comment.char,
		      col.names=list(col.names),
		      colClasses=list(colClasses)))

}
