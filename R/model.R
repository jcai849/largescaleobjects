dlm <- function(formula, data, weights=NULL, sandwich=FALSE) {
        stopifnot(is.distObjRef(data))
        chunks <- chunkRef(distObjRef)
        stopifnot(length(chunks) > 0L)
        init <- dbiglm(formula, chunks[[1]], weights, sandwich)
        if (length(chunks) != 1L)
                dreduce("biglm::update.biglm", chunks[-1], init)
        else init
}

dbiglm <- function(formula, data, weights=NULL, sandwich=FALSE) {
        stopifnot(is.chunkRef(data))
        do.ccall("do.NEAcall",
                 list(what="biglm::biglm",
                      args=list(formula=stripEnv(formula),
                                data=data,
                                weights=stripEnv(weights),
                                sandwich=sandwich)),
                 target=data)
}
