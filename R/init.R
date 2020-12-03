registerNodes <- function(...) {
	lapply(store, args)
	init(args)
}

dist.read <- function(filePath, colClasses, ...) {
	chunkSize <- ceiling(nlines / length(ls(nodes())))
	chunks <- mapply(send, 
			 iotools::chunk.reader(filePath, colClasses, chunkSize, ...),
			 to=eapply(name, nodes()))
	as.distObjRef(chunks)
}
