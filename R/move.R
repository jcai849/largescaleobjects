findTarget <- function(args) {
	dist <- vapply(args, is.distObjStub, logical(1))
	if (!any(dist)) return(root())
	sizes <- lapply(args[dist], function(x) sum(size(x)))
	args[dist][[which.max(sizes)]] # largest 
}

is.AsIs <- function(x) inherits(x, "AsIs")
unAsIs <- function(x) {
	class(x) <- class(x)[!class(x) == "AsIs"]
	x
}

# unstub dispatches on arg

unstub.default <- function(arg, target) arg

unstub.AsIs <- function(arg, target) unAsIs(arg)

unstub.chunkStub <- function(arg, target) {
	tryCatch(get(as.character(desc(arg)), envir = .largeScaleRChunks),
		 error = function(e) osrvGet(arg))
}

unstub.distObjStub <- function(arg, target) {
	if (missing(target)) {
		chunks <- sapply(chunkStub(arg), unstub, 
				 simplify=FALSE, USE.NAMES=FALSE)
		names(chunks) <- NULL
		return(do.call(combine, chunks))
	}

	toAlign <- alignment(arg, target) 
	Stub <- sapply(toAlign$Stub, unstub,
		       simplify=FALSE, USE.NAMES=FALSE)
	names(Stub) <- NULL

	if (length(Stub) == 1) {
		index(Stub[[1]], seq(toAlign$HEAD$FROM, toAlign$HEAD$TO))
	} else do.call(combine, 
		       c(list(index(Stub[[1]], seq(toAlign$HEAD$FROM, 
						  toAlign$HEAD$TO))), 
			 Stub[-c(1, length(Stub))], 
			 list(index(Stub[[length(Stub)]], seq(toAlign$TAIL$FROM,
							    toAlign$TAIL$TO)))))
}

# stub dispatches on target

stub.distObjStub <- function(arg, target) {
	if (is.distObjStub(arg) ||
	    is.chunkStub(arg)   ||
	    is.AsIs(arg))
		return(arg)
	splits <- split(arg, cumsum(seq(size(arg)) %in% from(target)))
	chunks <- mapply(stub,
			 splits, chunkStub(target)[seq(length(splits))],
			 SIMPLIFY = FALSE, USE.NAMES=FALSE)
	names(chunks) <- NULL
	x <- distObjStub(chunks)
	x
}

stub.chunkStub <- function(arg, target) {
	do.call.chunkStub("identity", list(arg), target = target)
}

# scatter into <target>-many pieces over the general cluster
stub.integer <- function(arg, target) {
	stopifnot(target > 0)
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

osrvGet <- function(x) {
	stateLog(paste("RCV", desc(getUserProcess()),
		       desc(x))) # RCV X Y - Receiving at worker X, chunk Y
	unserialize(osrv::ask(paste("GET", desc(x)), host(x), port(x)))
}
