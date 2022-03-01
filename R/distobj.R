emerge <- function(x) {
	do.call(unclass(x)$combination, lapply(unclass(x)$chunks, largerscale::pull))
}

Math.DistributedObject <- function(x, ...) 
	do.dcall(.Generic, c(list(x=x), list(...)))

Ops.DistributedObject <- function(e1, e2) 
	if (missing(e2)) { do.dcall(.Generic, list(e1=e1)) 
	} else             do.dcall(.Generic, list(e1=e1, e2=e2))

Complex.DistributedObject <- function(z) 
	do.dcall(.Generic, list(z=z))

Summary.DistributedObject <- function(..., na.rm = FALSE) {
	mapped <- emerge(do.dcall(.Generic, c(list(...), list(na.rm=I(na.rm)))))
	do.call(.Generic, c(list(mapped), list(na.rm=na.rm)))
}

`$.DistributedObject` <- function(x, name)
	do.dcall("$", list(x=x, name=I(name)))

table.DistributedObject <- function(...)
	emerge(do.dcall("table", list(...)))

subset.DistributedObject <- function(x, subset, ...)
	do.dcall("subset", c(list(x=x, subset=subset), list(...)))

dim.DistributedObject <- function(x) {
	dims <- emerge(do.dcall("dim", list(x=x)))
	c(sum(dims[1,]), dims[,1][-1])
}

size <- function(measure) function(x) sum(do.dcall(measure, x))
length.DistributedObject <- size(length)
nrow.DistributedObject <- size(nrow)
