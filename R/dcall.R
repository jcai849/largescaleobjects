do.dcall <- function(what, args, size_change=FALSE) {
	dist_obj_args <- sapply(args, inherits, "DistributedObject")
	args[!dist_obj_args] <- lapply(args, split, args[dist_obj_args][1])
	alignment <- align(args)
	chunks <- apply(alignment, 1, function(i) largerscale::remote_call(what, args, alignment), simplify=FALSE)
	size <- if (size_change) {
		lapply(chunks, function(chunk) largerscale::remote_call("size", chunk))
	} else rowSums(alignment)
	structure(list(chunks=chunks, size=size, combination=c), class="DistributedObject")
}

distribute.distObjRef <- function(arg, target) {
	if (is.distObjRef(arg) ||
	    is.chunkRef(arg)   ||
	    is.AsIs(arg))
		return(arg)
	splits <- split(arg, cumsum(seq(size(arg)) %in% from(target)))
	chunks <- mapply(distribute,
			 splits, chunkRef(target)[seq(length(splits))],
			 SIMPLIFY = FALSE, USE.NAMES=FALSE)
	names(chunks) <- NULL
	x <- distObjRef(chunks)
	x
}

distribute.chunkRef <- function(arg, target) {
	do.ccall("identity", list(arg), target = target)
}

# scatter into <target>-many pieces over the general cluster
distribute.integer <- function(arg, target) {
	stopifnot(target > 0)
	chunks <- if (target == 1) {
		list(arg) 
		} else split(arg, cut(seq(size(arg)), breaks=target))
	names(chunks) <- NULL
	chunkRefs <- sapply(chunks, function(chunk)
			     do.ccall("identity", list(chunk),
					       root()),
			     simplify = FALSE, USE.NAMES = FALSE)
	names(chunkRefs) <- NULL
	distObjRef(chunkRefs)
}

alignment <- function(arg, target) {
	stopifnot(is.distObjRef(arg),
		  is.chunkRef(target))

	toAlign 	<- list()
	argChunks	<- chunkRef(arg)
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
