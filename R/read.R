read.dcsv <- function(dests, header=FALSE, sep=",", skip=0L, fileEncoding="",
                      colClasses, nrows=-1L, nsep=NA, strict=TRUE, nrowsClasses=25L, quote="\"") {
	tokens <- lapply(dests, chunknet::extract, pattern="(.*):(.*)", split=";")
	split_dests <- mapply(function(t, d) if (is.null(t)) c("localhost", d) else t, tokens, dests)
	hosts <- split_dests[1,]
	paths <- split_dests[2,]
	locations <- chunknet::get_host_locations(hosts)
	chunks <- chunknet::push(paths, locations)
	do.dcall(iotools::read.csv.raw,
		 list(file=DistributedObject(chunks),
		      header=header,
		      sep=sep,
                      skip=skip,
                      fileEncoding=fileEncoding,
                      colClasses=colClasses,
                      nrows=nrows,
                      nsep=nsep,
                      strict=strict,
                      nrowsClasses=nrowsClasses,
                      quote=quote))
}
