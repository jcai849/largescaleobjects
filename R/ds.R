# Descriptors

desc <- function(x, ...) UseMethod("desc", x)
`desc<-` <- function(x, value) UseMethod("desc<-", x)
desc.character <- function(x, ...)
        structure(rediscc::redis.inc(msg(), x), class="desc")

# Caches

cache <- function(x, mutable) {
        if (missing(x)) {
                return(structure(if (mutable) new.env(TRUE, emptyenv())
                                 else list(), class="cache"))
        } else UseMethod("cache", x)
}
`cache<-` <- function(x, value) UseMethod("cache<-", x)
`cache[[<-` <- function(x, i, value) {
	if (is.null(value)) {
		if (is.environment(x)) return(rm(list=i, x))
	}
	x[[i]] <- value
}

# Refs

ref <- function(x, ...) {
        if (missing(x)) {
                structure(list(), class="ref")
        } else UseMethod("ref")
}
`ref<-` <- function(x, value) UseMethod("ref", x)
