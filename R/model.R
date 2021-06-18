dlm <- function(formula, data, weights=NULL, sandwich=FALSE) {
        stopifnot(is.distObjRef(data))
        chunks <- chunkRef(distObjRef)
        stopifnot(length(chunks) > 0L)
	init <- do.ccall("biglm::biglm",
			 list(formula=stripEnv(formula),
			      data=chunks[[1]],
			      weights=stripEnv(weights),
			      sandwich=sandwich),
			 target=chunks[[1]],
			 mask=list(sys.call=makeCallFun(sys.call, 1)))
        if (length(chunks) != 1L)
                dreduce("biglm::update.biglm", chunks[-1], init)
        else init
}
