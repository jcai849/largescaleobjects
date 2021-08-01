# Refs

cref <- function(x, ...) {
	if (!missing(x)) {
		UseMethod("cref", x)
	} else {
		cref(crcache())
	}
}
ref.crcache <- cref.crcache <- function(x, ...) {
	cr <- ref()
	class(cr) <- c("cref", class(cr))
	crcache(cr) <- x
	cr
}
ref.cdesc <- cref.cdesc <- function(x, ...) cref(crcache(x))
ref.dref <- cref.dref <- function(x, ...) x[["cr"]]
`cref<-` <- function(x, value) UseMethod("cref<-", x)
`ref<-.dref` <- `cref<-.dref` <- function(x, value) { x[["cr"]] <- value; x }
cref.default <- function(x, ...) distribute(x) # base on size

clist <- function(...) {
	cl <- list(...)
	stopifnot(all(sapply(x, is.cref)))
	class(cl) <- c("clist", class(cl))
	cl
}

dref <- function(x, ...) UseMethod("dref", x)
dref.clist <- function(x, ...) {
	dr <- ref()
	class(dr) <- c("dref", class(dr))
	drcache(dr) <- drcache()
	cref(dr) <- x
	dr
}
dref.cref <- function(x, ...) dref(clist(x))
dref.cdesc <- function(x, ...) dref(cref(x))
dref.default <- function(x, ...) distribute(x) # base on size

# Caches

crcache <- function(x, ...) {
	if (!missing(x)) {
		UseMethod("crcache", x)
	} else {
		crcache(cdesc())
	}
}
crcache.cdesc <- crcache.character <- function(x, ...) {
	cc <- cache(mutable=TRUE)
	class(cc) <- c("crcache", class(cc))
	cc[["cd"]] <- x
	reg.finalizer(cc, delete)
	cc
}
cache.cref <- crcache.cref <- function(x, ...) x[["cc"]]
crcache.dref <- function(x, ...) lapply(cref(x), crcache)
`crcache<-` <- function(x, value) UseMethod("crcache<-", x)
`cache<-.cref` <- `crcache<-.cref` <- function(x, value) { x[["cc"]] <- value; x }

drcache <- function(x, ...) {
	if (missing(x)) {
		dc <- cache(mutable=FALSE)
		class(dc) <- c("drcache", class(dc))
		return(dc)
	}
	UseMethod("drcache", x)
}
cache.dref <- drcache.dref <- function(x, ...) x[["dc"]]

# Descriptors

cdesc <- function(x, ...) {
	if (missing(x)) {
		cd <- desc("cd")
		class(cd) <- c("cdesc", class(cd))
		cd
	} else UseMethod("cdesc", x)
}
cdesc.character <- function(x, ...) {
	class(x) <- c("cdesc", class(x))
	x
}
desc.crcache <- cdesc.crcache <- function(x, ...) x[["cd"]]
desc.dref <- cdesc.dref <- function(x, ...) sapply(cref(x), cdesc)

# Deletion

delete <- function(x, ...) UseMethod("delete", x)
delete.cdesc <- function(x, ...) {
	chunk(x) <- NULL
	log("DEL", x)
	gc()
}
delete.crcache <- function(x, ...) {
	if (is.null(cdesc(x))) return()
	do.ccall(delete, args=list(x=cdesc(x)), target=cdesc(x), store=FALSE)
	osrv::ask(paste0("DEL", cdesc(x), "\n"),
		  host=host(x), port=port(x), sfs=TRUE)
	rm(list=ls(x), x)
	return()
}

# Utils

is.desc		<- function(x) inherits(x, "desc")
is.cdesc	<- function(x) inherits(x, "cdesc")
is.cache	<- function(x) inherits(x, "cache")
is.crcache	<- function(x) inherits(x, "crcache")
is.drcache	<- function(x) inherits(x, "drcache")
is.ref		<- function(x) inherits(x, "ref")
is.cref		<- function(x) inherits(x, "cref")
is.dref		<- function(x) inherits(x, "dref")

format.desc	<- function(x, ...) format(unclass(x))
format.cache	<- function(x, ...) format(as.list(unclass(x)))
format.cref	<- function(x, ...) format(crcache(x))
format.dref	<- function(x, ...) sapply(cref(x), format)

catformat	<- function(x, ...) cat(format(x), "\n")
print.desc	<- catformat
print.cache	<- catformat
print.cref	<- catformat
print.dref	<- catformat
