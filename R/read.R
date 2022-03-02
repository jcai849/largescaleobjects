read.dcsv <- function(hosts, paths, header=FALSE, sep=",", quote="\"",
		      dec=".", fill=TRUE, comment.char="", col.names, colClasses) {
	chunks <- mapply(largerscale::push, paths, hosts,
			 SIMPLIFY=FALSE, USE.NAMES=FALSE)
	do.dcall(read.csv,
		 list(file=structure(list(chunks=chunks), class="DistributedObject"),
		      header=header,
		      sep=sep,
		      quote=quote,
		      dec=dec,
		      fill=fill,
		      comment.char=comment.char,
		      col.names=col.names,
		      colClasses=colClasses),
		 combination=rbind)
}
