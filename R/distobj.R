# Instantiate
# Distributed environments

denvref <- function(target)
	structure(do.dcall(envBase(function(null)
				   structure(new.env(parent=baseenv()),
					     class="denv")), list(target)),
		  class=c("denvref", class(target)))

is.denvref <- function(x) inherits(x, "denvref")
is.denv <- function(x) inherits(x, "denv")

# vars is to be a named list of additional variables to send, with said names
# corresponding to names in expr
with.dref <- function(data, expr, vars=list(), result=TRUE) {
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

Math.dref <- function(x, ...) 
	do.dcall(.Generic, c(list(x=x), list(...)))

Ops.dref <- function(e1, e2) 
	if (missing(e2)) {
		do.dcall(.Generic, list(e1=e1)) 
	} else  do.dcall(.Generic, list(e1=e1, e2=e2))

Complex.dref <- function(z) 
	do.dcall(.Generic, list(z=z))

Summary.dref <- function(..., na.rm = FALSE) {
	mapped <- emerge(do.dcall(.Generic,
				  c(list(...),
				    list(na.rm=I(na.rm)))))
	do.call(.Generic, c(list(mapped), list(na.rm=na.rm)))
}

`$.dref` <- function(x, name)
	do.dcall("$", list(x=x, name=I(name)))

table.dref <- function(...)
	emerge(do.dcall("table", list(...)))

subset.dref <- function(x, subset, ...)
	do.dcall("subset", c(list(x=x, subset=subset), list(...)))

dim.dref <- function(x) {
	dims <- sapply(cref(do.dcall("dim", list(x=x))), emerge)
	c(sum(dims[1,]), dims[,1][-1])
}

length.dref <- function(x) sum(size(x))
nrow.dref <- function(x) sum(size(x))
ncol.dref <- function(x) ncol(cref(x)[[1]])
colnames.dref <- function(x, ...) colnames(cref(x)[[1]])
cbind.dref <- function(..., deparse.level = 1) do.dcall("cbind", list(...))
rbind.dref <- function(...) combine(...)
c.dref <- function(...) combine(...)
combine.dref <- function(...) {
	chunks <- do.call(c, (lapply(list(...), cref)))
	x <- dref(chunks)
	to(dref) <- NULL
	from(dref) <- NULL
	x
}
object.dsize <- function(x) sum(do.dcall("object.size", list(x)))
