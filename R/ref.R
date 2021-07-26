# Descriptors

cdesc <- function(x, ...) {
	if (missing(x)) {
		cd <- desc("cd")
		class(cd) <- c("cdesc", class(cd))
		return(cd)
	} else UseMethod("cdesc", x)
}
desc.ccache <- cdesc.ccache <- function(x, ...) x$cd
desc.dref <- cdesc.dref <- function(x, ...) sapply(cref(x), cdesc)

# Caches

ccache <- function(x, ...) UseMethod("ccache", x)
ccache.cdesc <- function(x, ...) {
	cc <- cache(mutable=TRUE)
	class(cc) <- c("ccache", class(cc))
	cc$cd <- x
	reg.finalizer(cc, delete)
	cc
}
cache.cref <- ccache.cref <- function(x, ...) x$cc
ccache.dref <- function(x, ...) lapply(cref(x), ccache)
`ccache<-` <- function(x, value) UseMethod("ccache<-", x)
`cache<-.cref` <- `ccache<-.cref` <- function(x, value) {x$cc <- value; x}

dcache <- function(x, ...) {
	if (missing(x)) {
		dc <- cache(mutable=FALSE)
		class(dc) <- c("dcache", class(dc))
		return(dc)
	}
	UseMethod("dcache", x)
}
cache.dref <- dcache.dref <- function(x, ...) x$dc

# Refs

cref <- function(x, ...) UseMethod("cref", x)
ref.ccache <- cref.ccache <- function(x, ...) {
	cr <- ref()
	class(cr) <- c("cref", class(cr))
	ccache(cr) <- x
	cr
}
ref.cdesc <- cref.cdesc <- function(x, ...) cref(ccache(x))
ref.dref <- cref.dref <- function(x, ...) x$cr
`cref<-` <- function(x, value) UseMethod("cref<-", x)
`ref<-.dref` <- `cref<-.dref` <- function(x, value) {x$cr <- value; x}

dref <- function(x, ...) UseMethod("dref", x)
dref.list <- function(x, ...) {
	stopifnot(all(sapply(x, is.cref)))
	dr <- ref()
	class(dr) <- c("dref", class(dr))
	dcache(dr) <- dcache()
	cref(dr) <- x
	dr
}

# Deletion

delete <- function(x, ...) UseMethod("delete", x)
delete.cdesc <- function(x, ...) {
	# delete chunk with descriptor x from local chunkStore
	rm(list=as.character(x), pos=getChunkStore())
	stateLog(paste("DEL", desc(getUserProcess()), x))
	gc()
}
delete.ccache <- function(x, ...) {
	if (is.null(cdesc(x))) return()
	do.ccall(delete, args=list(x=cdesc(x)), target=cdesc(x), store=FALSE)
	osrv::ask(paste0("DEL", cdesc(x), "\n"),
		  host=host(x), port=port(x), sfs=TRUE)
	rm(list=ls(x), pos=x)
	return()
}

# Utils

is.desc		<- function(x) inherits(x, "desc")
is.cdesc	<- function(x) inherits(x, "cdesc")
is.cache	<- function(x) inherits(x, "cache")
is.ccache	<- function(x) inherits(x, "ccache")
is.dcache	<- function(x) inherits(x, "dcache")
is.ref		<- function(x) inherits(x, "ref")
is.cref		<- function(x) inherits(x, "cref")
is.dref		<- function(x) inherits(x, "dref")

format.desc	<- function(x, ...) format(unclass(x))
format.cache	<- function(x, ...) format(as.list(unclass(x)))
format.cref	<- function(x, ...) format(ccache(x))
format.dref	<- function(x, ...) sapply(cref(x), format)

catformat	<- function(x, ...) cat(format(x), "\n")
print.desc	<- catformat
print.cache	<- catformat
print.cref	<- catformat
print.dref	<- catformat
