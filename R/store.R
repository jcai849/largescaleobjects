store <- function(name) {
	function(x, ...) {
		if (!missing(x)) {
			UseMethod(x)
		} else {
			st <- get0(name, -2, inherits=FALSE)
			if (is.null(st)) {
				st <- cache(mutable=TRUE)
				class(st) <- c(name, "store", class(st))
				assign(name, st, -2)
			}
			st
		}
	}
}

cstore <- store("cstore")
lstore <- store("lstore")
`cstore<-` <- function(x, value) UseMethod("cstore<-", x)

cstore.character <- function(x) get(x, cstore())
cstore.cdesc <- cstore.numeric <- function(x) cstore(as.character(x))

`cstore<-.character` <- function(x, value)
	{ st <- cstore(); st[[x]] <- value; x }
`cstore<-.cdesc` <- `cstore<-.numeric` <- function(x, value)
	{ x <- as.character(x); cstore(x) <- value; x }

lstore.character <- function(what, conninit, ...) {
        ncx <- lstore()[[what]]
        if (is.null(ncx)) {
                ncx <- lstore()[[what]] <- loc()
        } else if (is.null(conn(ncx)) &&
                   !is.null(host(ncx))
                   !is.null(host(ncx))) {
                conn(ncx) <- conninit(host(ncx), port(ncx), ...)
        }
        ncx
}
