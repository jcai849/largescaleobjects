read.dcsv <- function(dests, header=FALSE, sep=",", quote="\"",
		      dec=".", fill=TRUE, comment.char="", col.names, colClasses) {
	tokens <- lapply(dests, chunknet::extract, pattern="(.*):(.*)", split=";")
	split_dests <- mapply(function(t, d) if (is.null(t)) c("localhost", d) else t, tokens, dests)
	hosts <- split_dests[1,]
	paths <- split_dests[2,]
	locations <- chunknet::get_host_locations(hosts)
	chunks <- chunknet::push(paths, locations)
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
