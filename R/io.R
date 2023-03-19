# Returns a distributed object with each chunk being a char vector naming its destination path
dpath <- function(dests) {
	tokens <- lapply(dests, chunknet::extract, pattern="(.*):(.*)", split=";")
	split_dests <- mapply(function(t, d) if (is.null(t)) c("localhost", d) else t, tokens, dests)
	hosts <- split_dests[1,]
	paths <- split_dests[2,]
	locations <- chunknet::get_host_locations(hosts)
	DistributedObject(chunknet::push(paths, locations))
}

read.dcsv <- function(dests, header=FALSE, sep=",", skip=0L, fileEncoding="",
                      colClasses, nrows=-1L, nsep=NA, strict=TRUE, nrowsClasses=25L, quote="\"") {
	do.dcall(iotools::read.csv.raw,
		 list(file=dpath(dests), header=header, sep=sep, skip=skip, fileEncoding=fileEncoding,
			  colClasses=colClasses, nrows=nrows, nsep=nsep, strict=strict,
			  nrowsClasses=nrowsClasses, quote=quote))
}

read.dmatrix <- function(dests, type=c("numeric", "character", "logical", "integer",  "complex", "raw"),
						 ddim=dim(dests), sep="|", nsep=NA, strict=TRUE, ncol = NA, skip=0L, nrows=-1L, quote="") {
	x <- do.dcall(iotools::input.file,
				  list(file_name=dpath(dests), sep=sep, nsep=nsep, strict=strict,
				       ncol=ncol, type=type, skip=skip, nrows=nrows, quote=quote))
	dim(x) <- if (is.null(ddim)) dim(x) else ddim
	x
}

read.lcsv <- function(file, col_types, sep=",", quote="",
                      max.line=65536L, max.size=50L*1024L^2L) {
	iotools::chunk.apply(iotools::chunk.reader(file, max.line=max.line),
                             function(chunk) do.dcall(iotools::dstrsplit,
                                                      list(x=chunk, col_types=col_types,
                                                           sep=sep, quote=quote)),
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

checkpoint <- function(x, pattern="largescaler", dir=tempdir(), ...) {
	cp <- function(x, pattern, dir) {
		fp <- tempfile(pattern, dir)
		saveRDS(x, fp)
		fp
	}
	chunks <- do.dcall(cp, list(x, pattern, dir))
        structure(list(loc=location(chunks), fp=emerge(chunks)), class="Checkpoint")
}

restore <- function(x, ...) UseMethod("restore", x)
restore.Checkpoint <- function(x, ...) restore(x=x$loc, path=x$fp)
restore.Location <- function(x, fp, ...) {
	chunks <- chunknet::push(fp, x)
	d(readRDS)(chunks)
}

print.Checkpoint <- function(x, ...) cat("Checkpoint of", length(x), "chunks\n")
