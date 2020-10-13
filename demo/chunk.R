############################### Initialisation ################################

invisible(parallel::mcparallel({
	library(distObj)

	distInit(verbose=T)
	chunk1 <- seq(10)
	addChunk("chunk1", chunk1)

	server()
}))

############################### Initialisation ################################
library(distObj)
distInit(verbose=T)
# Clear any previous examples
rediscc::redis.rm(conn(), c("chunkRef1", paste0("C", 1:10), paste0("J", 1:10), 
		"JOB_ID", "CHUNK_ID"))
# Create new example object
chunk1 <- structure(new.env(), class = "chunkRef")
chunkID(chunk1) <- structure("chunk1", class="chunkID")
jobID(chunk1) <- structure("job1", class="jobID")
preview(chunk1) <- 1:5
resolution(chunk1) <- "RESOLVED"

chunk1

invisible(readline()) ##### [44mAssign Chunk Reference[0m #################

x <- do.call.chunkRef(what="expm1", args=list(x=chunk1), target=chunk1)
resolve(x)

invisible(readline()) ##### [44mAssign Chunk Reference with Failure[0m ####

y <- do.call.chunkRef("as.Date", args=list(x=x), target=x)

invisible(readline()) ##### [44mLocal Operations while Chunks Resolve[0m ##

expm1(x=1:10)

invisible(readline()) ##### [44mPreview of Successful Chunk[0m ############

x

invisible(readline()) ##### [44mValue of Successful Chunk[0m ##############

emerge(x)

invisible(readline()) ##### [44mResolution of Unsuccessful Chunk[0m #######

resolve(y)
y
emerge(y)
