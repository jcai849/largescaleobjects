# Instantiate

distObjRef <- function(x) {
	stopifnot(all(sapply(x, is.chunkRef)))
	dos <- new.env(TRUE, emptyenv())
	class(dos) <- "distObjRef"
	chunkRef(dos) <- x
	dos
}

is.distObjRef <- function(x) inherits(x, "distObjRef")
is.distributed <- function(x) is.distObjRef(x) | is.chunkRef(x)

chunkRef.distObjRef <- function(x, ...) get("chunk", x, inherits=FALSE)

preview.distObjRef <- function(x, ...) lapply(chunkRef(x), preview)

print.distObjRef <- function(x, ...) {
	cat("Distributed Object Reference with", format(length(chunkRef(x))), 
	    "chunk references\n")
	cat("First chunk reference:\n")
	print(chunkRef(x)[[1]])
}

# Distributed environments

denvRef <- function(target)
	structure(do.dcall(envBase(function(null)
				   structure(new.env(parent=baseenv()),
					     class="denv")), list(target)),
		  class=c("denvRef", class(target)))

is.denvRef <- function(x) inherits(x, "denvRef")
is.denv <- function(x) inherits(x, "denv")

# vars is to be a named list of additional variables to send, with said names
# corresponding to names in expr
with.distObjRef <- function(data, expr, vars=list(), result=TRUE) {
	stopifnot(is.list(vars), length(names(vars)) == length(vars))
	wfun <- as.function(c(alist(data=),
				structure(rep(alist(placeholder=), length(vars)),
					  names=names(vars)),
				substitute({
					n <- sys.nframe()
					e <- sys.frame(n)
					p <- parent.env(data)
					parent.env(data) <- e
					out <- with(data, expr)
					parent.env(data) <- p
					out
				},
				list(expr=substitute(expr)))))
	do.dcall(envBase(wfun), c(list(data), vars), store=result)
}


# User-level

Math.distObjRef <- function(x, ...) 
	do.dcall(.Generic, 
			   c(list(x=x), list(...)))

Ops.distObjRef <- function(e1, e2) 
	if (missing(e2)) {
		do.dcall(.Generic,
				   list(e1=e1)) 
	} else
		do.dcall(.Generic,
				   list(e1=e1, e2=e2))

Complex.distObjRef <- function(z) 
	do.dcall(.Generic,
			   list(z=z))

Summary.distObjRef <- function(..., na.rm = FALSE) {
	mapped <- emerge(do.dcall(.Generic,
				  c(list(...),
				    list(na.rm=I(na.rm)))))
	do.call(.Generic, 
		c(list(mapped), list(na.rm=na.rm)))
}

`$.distObjRef` <- function(x, name)
	do.dcall("$", list(x=x, name=I(name)))

table.distObjRef <- function(...)
	emerge(do.dcall("table",
				  list(...)))

subset.distObjRef <- function(x, subset, ...)
	do.dcall("subset", c(list(x=x, subset=subset), list(...)))

dim.distObjRef <- function(x) {
	dims <- sapply(chunkRef(do.dcall("dim", list(x=x))), emerge)
	c(sum(dims[1,]), dims[,1][-1])
}

length.distObjRef <- function(x) sum(size(x))
nrow.distObjRef <- function(x) sum(size(x))
ncol.distObjRef <- function(x) ncol(chunkRef(x)[[1]])
colnames.distObjRef <- function(x, ...) colnames(chunkRef(x)[[1]])
cbind.distObjRef <- function(..., deparse.level = 1) do.dcall("cbind", list(...))
rbind.distObjRef <- function(...) combine(...)
c.distObjRef <- function(...) combine(...)
combine.distObjRef <- function(...) {
	chunks <- do.call(c, (lapply(list(...), chunkRef)))
	for (chunk in chunks) suppressWarnings(rm(list=c("to", "from"), chunk))
	x <- distObjRef(chunks)
	x
}
object.dsize <- function(x) sum(do.dcall("object.size", list(x)))
