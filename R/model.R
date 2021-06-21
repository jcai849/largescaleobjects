dlm <- function(formula, data, weights=NULL, sandwich=FALSE) {
        stopifnot(is.distObjRef(data))
        chunks <- chunkRef(data)
        stopifnot(length(chunks) > 0L)
	currcall <- sys.call()
	scform <- c(alist(...=), call("quote", currcall))
	init <- do.ccall("biglm::biglm",
			 list(formula=stripEnv(formula),
			      data=chunks[[1]],
			      weights=stripEnv(weights),
			      sandwich=sandwich),
			 target=chunks[[1]],
			 mask=list(sys.call=scform))
        if (length(chunks) != 1L)
                dreduce("biglm::update.biglm", distObjRef(chunks[-1]), init)
        else init
}
