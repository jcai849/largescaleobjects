findTarget <- function(args) {
	dist <- vapply(args, is.distObjRef, logical(1))
	sizes <- lengths(lapply(args[dist], chunk))
	args[dist][[which.max(sizes)]] # longest
}

refToRec.chunkRef <- function(arg, target) chunk(arg)

refToRec.distObjRef <- function(arg, target) {
	toAlign <- alignment(arg, target) 

	ref <- lapply(toAlign$REF, emerge)
	combined <- if (length(ref) == 1) {
		ref[[1]][seq(toAlign$HEAD$FROM, toAlign$HEAD$TO)] 
	} else do.call(combine, 
		       c(list(ref[[1]][seq(toAlign$HEAD$FROM, 
					   toAlign$HEAD$TO)]), 
			 ref[-c(1, length(ref))], 
			 list(ref[[length(ref)]][seq(toAlign$TAIL$FROM,
						     toAlign$TAIL$TO)])))
	combined
}

# `alignment` returns list of form:
#  .
#  ├── HEAD
#  │   ├── FROM
#  │   └── TO
#  ├── REF
#  └── TAIL
#      ├── FROM
#      └── TO
alignment <- function(arg, target) {
	stopifnot(is.distObjRef(arg),
		  is.chunkRef(target))

	toAlign 	<- list()
	argChunks	<- chunk(arg)
	argFrom 	<- from(arg)
	argTo 		<- to(arg)
	argSize 	<- sum(size(arg))
	targetFrom 	<- from(target)
	targetTo 	<- to(target)
	targetSize 	<- size(target)

	# (x-1%%y)-1 to force a 1->n cycle instead of 0->n-1 for R's 1-indexing
	headFromAbs <- ((targetFrom-1L) %% argSize)+1L
	headRefNum <- which(headFromAbs <= argTo)[1]
	headFromRel <- headFromAbs - argFrom[headRefNum] + 1L

	tailToAbs <- if (targetSize > argSize)  #clip rep, force local recycling
		((headFromAbs-2L)%%argSize)+1L else ((targetTo-1L)%%argSize)+1L
	tailRefNum <- which(tailToAbs <= argTo)[1]
	tailToRel <- tailToAbs - argFrom[tailRefNum] + 1L

	ref <- if (targetSize+headFromAbs-1 > argTo[headRefNum] && 
		   tailRefNum<=headRefNum) # modular
		c(seq(headRefNum, length(argChunks)), seq(1L, tailRefNum)) else
			seq(headRefNum, tailRefNum)

	toAlign <- list()
	toAlign$HEAD$FROM <- headFromRel
	toAlign$HEAD$TO <- if (length(ref) == 1) 
		tailToRel else argTo[headRefNum] - argFrom[headRefNum] + 1L
	toAlign$REF <- argChunks[ref]
	toAlign$TAIL$FROM <- 1L
	toAlign$TAIL$TO <- tailToRel

	toAlign
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
	info("Getting the referent of the reference with chunkID", chunkID(x), 
	     "from port", format(port(x)), 
	     "at host", format(host(x)))
	s <- socketConnection(host(x), port=port(x), open="a+b")
	v <- osrvCmd(s, paste0("GET", " ", chunkID(x), "\n"))
	unserialize(v)
}
