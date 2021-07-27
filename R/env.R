addChunk <- function(cd, val) {
	if (is.environment(val)) val <- as.list(val)
	chunks(cd) <- val
	osrv::put(as.character(cd), val, sfs=TRUE)
	log("SVD", cd) # SVD X Y - Saving at worker X, chunk Y
	val
}

envbase <- function(x) {
        if (!is.null(x)) attr(x, ".Environment") <- baseenv()
        x
}

currCallFun <- function(n=0) { 
	cl <- sys.call(n-1)
	as.function(c(alist(...=), call("quote", cl)))
}
