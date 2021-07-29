# Descriptors

desc <- function(x, ...) UseMethod("desc", x)
desc.character <- function(x, ...)
        structure(redis.inc(msgconn(), x), class="desc")
`desc<-` <- function(x, value) UseMethod("desc<-", x)

# Caches

cache <- function(x, mutable) {
        if (missing(x)) {
                return(structure(if (mutable) new.env(TRUE, emptyenv())
                                 else list(), class="cache"))
        } else UseMethod("cache", x)
}
`cache<-` <- function(x, value) UseMethod("cache<-", x)

# Refs

ref <- function(x, ...) {
	if (missing(x)) return(structure(list(), class="ref"))
        else UseMethod("ref")
}
ref.ref <- identity 
`ref<-` <- function(x, value) UseMethod("ref", x)
