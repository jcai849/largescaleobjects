read.dcsv <- function(hosts, paths, header=FALSE, sep=",", quote="\"",
		      dec=".", fill=TRUE, comment.char="", col.names, colClasses) {
	locations <- chunknet::get_host_locations(hosts)
	chunks <- chunknet::push(hosts, locations)
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
