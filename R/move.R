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

	headFromAbs <- targetFrom %% argSize
	headRefNum <- which(headFromAbs <= argFrom)[1]
	headFromRel <- headFromAbs - argFrom[headRefNum] + 1L

	tailToAbs <- if (targetSize > argSize)  #clip rep, force local recycling
		headFromAbs - 1L %% argSize else targetTo %% argSize
	tailRefNum <- which(tailToAbs <= argTo)[1]
	tailToRel <- tailToAbs - argFrom[tailRefNum] + 1L

	ref <- if (targetSize + headFromAbs > argTo[headRefNum] && 
		   tailRefNum <= headRefNum) # modular
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
