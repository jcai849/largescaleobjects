# init function: see local.R

dist.read <- function(filePath, colClasses, ...) {
	startQueues <- startQueues()
	chunkSize <- ceiling(nlines / length(ls(startQueues)))
	chunks <- lapply(startQueues,
			 function(q)
				 do.call.chunkRef(what="iotools::chunk.reader",
						  args=list(filePath,
							    colClasses,
							    chunkSize, ...),
						  target=q))
	as.distObjRef(chunks)
}
