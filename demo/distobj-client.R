############################### Initialisation ################################

library(distObj)
distInit(verbose=T)
# Clear any previous examples
rediscc::redis.rm(conn(), c(paste0("chunk", 1:3), 
			    paste0("C", 1:20), paste0("J", 1:20),
			    "JOB_ID", "CHUNK_ID"))
# Create new example object
chunk1 <- structure(new.env(), class = "chunkRef")
chunkID(chunk1) <- structure("chunk1", class="chunkID")
jobID(chunk1) <- structure("job1", class="jobID")
preview(chunk1) <- 1:5
resolution(chunk1) <- "RESOLVED"

chunk2 <- structure(new.env(), class = "chunkRef")
chunkID(chunk1) <- structure("chunk2", class="chunkID")
jobID(chunk1) <- structure("job2", class="jobID")
preview(chunk1) <- 6:10
resolution(chunk1) <- "RESOLVED"

chunk3 <- structure(new.env(), class = "chunkRef")
chunkID(chunk1) <- structure("chunk3", class="chunkID")
jobID(chunk1) <- structure("job3", class="jobID")
preview(chunk1) <- 11:15
resolution(chunk1) <- "RESOLVED"

distObj1 <- structure(new.env(), class = "distObjRef")
chunks(distObj1) <- list(chunk1, chunk2, chunk3)

distObj1

invisible(readline()) ##### [44mAssign distObj Reference[0m #################

x <- do.call.distObjRef(what="expm1", args=list(x=distObj1))

invisible(readline()) ##### [44mAssign distObj Reference with Failure[0m ####

y <- do.call.distObjRef("as.Date", args=list(x=x))

invisible(readline()) ##### [44mLocal Operations while Chunks Resolve[0m ##

expm1(x=1:10)

invisible(readline()) ##### [44mPreview of Successful distObj[0m ############

x

invisible(readline()) ##### [44mValue of Successful distObj[0m ##############

do.call.distObjRef("identity", list(x), assign=FALSE)

invisible(readline()) ##### [44mResolution of Unsuccessful distObj[0m #######

resolve(y)
