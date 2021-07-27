length.cref <- function(x) 0L
ncol.cref <- function(x)
        emerge(do.ccall("ncol", list(x), x))
colnames.cref <- function(x, ...)
        emerge(do.ccall("colnames", list(x), x))
