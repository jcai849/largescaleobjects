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

read.lcsv <- function(file, col_types, sep=",", quote="",
                      max.line=65536L, max.size=50L*1024L^2L) {
	iotools::chunk.apply(iotools::chunk.reader(file, max.line=max.line),
                             function(chunk) do.dcall(iotools::dstrsplit,
                                                      list(x=chunk,
                                                           col_types=col_types,
                                                           sep=sep,
                                                           quote=quote)),
                              CH.MAX.SIZE=max.size)
}

write.dcsv <- function(x, file="", sep=',', nsep='\t', col.names=colnames(x), fileEncoding='') {
	x <- as.list(x)
	iotools::write.csv.raw(pull(x[[1]]), file, sep=sep, nsep=nsep, col.names=col.names, fileEncoding=fileEncoding)
	if (length(x) > 1L)
	for (chunk in x[-1])
            iotools::write.csv.raw(pull(chunk), file, append=TRUE, sep=sep,
                                   nsep=nsep, col.names=col.names, fileEncoding=fileEncoding)
	file
}

checkpoint <- function(x, pattern="largescaler", loc=tempdir(), ...) {
	chunks <- do.dcall(function(x, pattern, loc) saveRDS(x, tempfile(pattern, loc)), list(x, pattern, loc))
        data.frame(loc=location(chunks), path=emerge(chunks))
}

restore <- function(x, ...) UseMethod("restore", x)
restore.data.frame <- function(x, ...) restore(x=x$loc, path=x$path)
restore.Location <- function(x, path, ...) {
	chunks <- chunknet::push(path, x)
	d(readRDS)(chunks)
}
