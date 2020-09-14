# TODO findTarget

refToRec.chunkRef <- function(arg, target) chunk(arg)

refToRec.distObjRef <- function(arg, target) {
	toAlign <- alignment(arg, target) 
	headPiece <- 
		emerge(toAlign$HEAD$REF)[do.call(seq, toAlign$HEAD$INDICES)]
	innerPieces <- if (hasName(toAlign, "INNER")) {
		lapply(toAlign$INNER$REF, emerge) 
		} else NULL
	tailPiece <- if (hasName(toAlign, "TAIL")) {
		emerge(toAlign$TAIL$REF)[do.call(seq, toAlign$TAIL$INDICES)] 
		} else NULL
	do.call(c, c(headPiece, innerPieces, tailPiece))
}

# `alignment` returns list of form:
#  .
#  ├── HEAD
#  │   ├── INDICES
#  │   │   ├── FROM
#  │   │   └── TO
#  │   └── REF
#  ├── INNER
#  │   └── REF
#  └── TAIL
#      ├── INDICES
#      │   ├── FROM
#      │   └── TO
#      └── REF
alignment <- function(arg, target) {
	toAlign <- list()
	targetChunks <- chunk(target)
	if (size(arg) >= to(target)) {
		# get first true instance with which.max
		whichHead <- which.max(from(arg) > from(target)) - 1 
		whichTail <- which.min(from(arg) >= from(target)) - 1
		toAlign$HEAD$REF <- targetChunks[whichHead]
		if (whichTail-whichHead == 0) 
			toAlign$TAIL$REF <- targetChunks[whichTail]
		if (whichTail-whichHead == 0)
			toAlign$INNER$REF <- targetChunks[seq(whichHead, 
							      whichTail)]

		
		


	} else stop("TODO: fill in recycling case")
}
