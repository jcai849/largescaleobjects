############################### Initialisation ################################

library(distObj)
distInit(verbose=T)
# Clear any previous examples
rediscc::redis.rm(conn(), c(paste0("chunk", 1:3), 
			    paste0("C", 1:20), paste0("J", 1:20),
			    "JOB_ID", "CHUNK_ID"))
# Create new example object
chunk1 <- distObj:::makeTestChunk("chunk1", 1:5)
jobID(chunk1) <- jobID()
chunk2 <- distObj:::makeTestChunk("chunk2", 6:10)
jobID(chunk2) <- jobID()
chunk3 <- distObj:::makeTestChunk("chunk3", 11:15)
jobID(chunk3) <- jobID()

distObj1 <- structure(new.env(), class = "distObjRef")
chunk(distObj1) <- list(chunk1, chunk2, chunk3)

distObj1

invisible(readline()) ##### [44mAssign distObj Reference[0m #################

x <- do.call.distObjRef(what="expm1", args=list(x=distObj1))
resolve(x)

invisible(readline()) ##### [44mAssign Multivariate distObj Reference[0m #################

y <- do.call.distObjRef(what="+", args=list(x=distObj1, y=x))
resolve(y)

invisible(readline()) ##### [44mAssign distObj Reference with Failure[0m ####

z <- do.call.distObjRef("as.Date", args=list(x=x))

invisible(readline()) ##### [44mLocal Operations while Chunks Resolve[0m ##

expm1(x=1:10)

invisible(readline()) ##### [44mPreview of Successful distObj[0m ############

x
y

invisible(readline()) ##### [44mValue of Successful distObj[0m ##############

do.call.distObjRef("identity", list(x), assign=FALSE)
do.call.distObjRef("identity", list(y), assign=FALSE)

invisible(readline()) ##### [44mResolution of Unsuccessful distObj[0m #######

resolve(z)
