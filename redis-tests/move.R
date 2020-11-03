source("init.R")

# refToRec.distObjRef
stopifnot(
	  identical(1:5, refToRec(arg=distObj1, target=chunk1))
)

# recToRef.chunkRef
stopifnot(
	  identical(1:3, emerge(recToRef(1:3, chunk1))),
	  identical(1:10, emerge(recToRef(1:10, chunk1)))
)

# recToRef.distObjRef
stopifnot(
	  identical(1:3, emerge(recToRef(1:3, distObj1))),
	  identical(1:10, emerge(recToRef(1:10, distObj1))),
	  identical(1:20, emerge(recToRef(1:20, distObj1)))
)

clear()
