findTarget <- function(args) {
	log("finding target")
	dist <- vapply(args, is.distObjStub, logical(1))
	if (!any(dist)) return(root())
	sizes <- lengths(lapply(args[dist], chunkStub))
	args[dist][[which.max(sizes)]] # most dispersed
}

# unstub dispatches on arg

unstub.default <- function(arg, target) arg

unstub.chunkStub <- function(arg, target) {
	log(paste("unstubbing", paste(format(arg), collapse="\n")))
	tryCatch(get(as.character(desc(arg)), envir = .largeScaleRChunks),
		 error = function(e) {
			 resolve(arg)
			 osrvGet(arg)
		 })
}

unstub.distObjStub <- function(arg, target) {
	if (missing(target)) {
		chunks <- sapply(chunkStub(arg), unstub, 
				 simplify=FALSE, USE.NAMES=FALSE)
		names(chunks) <- NULL
		return(do.call(combine, chunks))
	}

	log(paste("unstubbing", paste(format(arg), collapse="\n"), 
		  "to", paste(format(target), collapse="\n")))

	resolve(target)
	resolve(arg)

	fromSame <- which(from(arg) == from(target)) 
	toSame <- which(to(arg) == to(target))
	if (identical(as.vector(fromSame), as.vector(toSame)) &&
	    length(fromSame) == 1 && length(toSame) == 1) {
		return(unstub(chunkStub(arg)[[fromSame]]))
	}

	toAlign <- alignment(arg, target) 
	Stub <- sapply(toAlign$Stub, unstub,
		       simplify=FALSE, USE.NAMES=FALSE)
	names(Stub) <- NULL

	combined <- if (length(Stub) == 1) {
		index(Stub[[1]], seq(toAlign$HEAD$FROM, toAlign$HEAD$TO))
	} else do.call(combine, 
		       c(list(index(Stub[[1]], seq(toAlign$HEAD$FROM, 
						  toAlign$HEAD$TO))), 
			 Stub[-c(1, length(Stub))], 
			 list(index(Stub[[length(Stub)]], seq(toAlign$TAIL$FROM,
							    toAlign$TAIL$TO)))))
	combined
}

# stub dispatches on target

stub.distObjStub <- function(arg, target) {
	log(paste("stubbing", paste(format(arg), collapse="\n"), 
		  "to", paste(format(target), collapse="\n")))
	if (is.distObjStub(arg) || is.chunkStub(arg)) return(arg)
	if (is.AsIs(arg)) return(unAsIs(arg))
	splits <- split(arg, cumsum(seq(size(arg)) %in% from(target)))
	chunks <- mapply(stub,
			 splits, chunkStub(target)[seq(length(splits))],
			 SIMPLIFY = FALSE, USE.NAMES=FALSE)
	names(chunks) <- NULL
	x <- distObjStub(chunks)
	resolve(x)
	x
}

stub.chunkStub <- function(arg, target) {
	log(paste("stubbing", paste(format(arg), collapse="\n"),
		  "to", paste(format(target), collapse="\n")))
	do.call.chunkStub("identity", list(arg), target = target)
}

# scatter into <target>-many pieces over the general cluster
stub.integer <- function(arg, target) {
	stopifnot(target > 0)
	log(paste("stubbing", paste(format(arg), collapse="\n"), "over", 
		  paste(format(target), collapse="\n"), "chunks"))
	chunks <- if (target == 1) {
		list(arg) 
		} else split(arg, cut(seq(size(arg)), breaks=target))
	names(chunks) <- NULL
	chunkStubs <- sapply(chunks, function(chunk)
			     do.call.chunkStub("identity", list(chunk),
					       root()),
			     simplify = FALSE, USE.NAMES = FALSE)
	names(chunkStubs) <- NULL
	distObjStub(chunkStubs)
}
stub.numeric <- stub.integer

# `alignment` returns list of form:
#  .
#  ├── HEAD
#  │   ├── FROM
#  │   └── TO
#  ├── Stub
#  └── TAIL
#      ├── FROM
#      └── TO
alignment <- function(arg, target) {
	stopifnot(is.distObjStub(arg),
		  is.chunkStub(target))

	toAlign 	<- list()
	argChunks	<- chunkStub(arg)
	argFrom 	<- from(arg)
	argTo 		<- to(arg)
	argSize 	<- sum(size(arg))
	targetFrom 	<- from(target)
	targetTo 	<- to(target)
	targetSize 	<- size(target)

	# (x-1%%y)-1 to force a 1->n cycle instead of 0->n-1 for R's 1-indexing
	headFromAbs <- ((targetFrom-1L) %% argSize)+1L
	headStubNum <- which(headFromAbs <= argTo)[1]
	headFromRel <- headFromAbs - argFrom[headStubNum] + 1L

	tailToAbs <- if (targetSize > argSize)  #clip rep, force local recycling
		((headFromAbs-2L)%%argSize)+1L else ((targetTo-1L)%%argSize)+1L
	tailStubNum <- which(tailToAbs <= argTo)[1]
	tailToRel <- tailToAbs - argFrom[tailStubNum] + 1L

	Stub <- if ((targetSize >= argSize && headFromAbs > argFrom[1]) ||
		   (targetSize < argSize && headFromAbs > tailToAbs)) # modular
		c(seq(headStubNum, length(argChunks)), seq(1L, tailStubNum)) else
			seq(headStubNum, tailStubNum)

	toAlign <- list()
	toAlign$HEAD$FROM <- headFromRel
	toAlign$HEAD$TO <- if (length(Stub) == 1) 
		tailToRel else argTo[headStubNum] - argFrom[headStubNum] + 1L
	toAlign$Stub <- argChunks[Stub]
	toAlign$TAIL$FROM <- 1L
	toAlign$TAIL$TO <- tailToRel

	toAlign
}

index <- function(x, i) {
       ndim <- if (is.null(dim(x))) 1L else length(dim(x))
       l <- as.list(quote(x[]))[3]
       eval(as.call(
                    c(list(quote(`[`)),
                      list(quote(x)),
                      list(quote(i)),
                      rep(l, ndim-1L))
                    ))
}

osrvCmd <- function(s, cmd) {
	writeBin(charToRaw(cmd), s)
	while (!length(a <- readBin(s, raw(), 32))) {}
	i <- which(a == as.raw(10))
	if (!length(i)) stop("Invalid answer")
	res <- gsub("[\r\n]+","",rawToChar(a[1:i[1]]))
	sr <- strsplit(res, " ", TRUE)[[1]]
	## object found
	if (sr[1] == "OK" && length(sr) > 1) {
		len <- as.numeric(sr[2])
		p <- if (i[1] < length(a)) a[-(1:i[1])] else raw()
		## read the rest of the object
		while (length(p) < len)
			p <- c(p, readBin(s, raw(), len - length(p)))
		p
	} else if (sr[1] == "OK") {
		TRUE
	} else stop("Answer: ", sr[1])
}

osrvGet <- function(x) {
	log(paste("retrieving chunk of descriptor", format(desc(x)),
			 "via osrv from host", format(host(x))))
	s <- socketConnection(host(x), port=port(x), open="a+b")
	sv <- osrvCmd(s, paste0("GET", " ", desc(x), "\n"))
	close(s)
	v <- unserialize(sv)
	v
}
