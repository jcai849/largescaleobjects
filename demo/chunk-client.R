############################### Initialisation ################################

library(distObj)
distInit(verbose=T)
# Clear any previous examples
rediscc::redis.rm(conn(), c("chunkRef1", paste0("C", 1:10), paste0("J", 1:10), 
		"JOB_ID", "CHUNK_ID"))
# Create new example object
chunk1 <- structure(new.env(), class = "chunkRef")
chunkID(chunk1) <- structure("chunk1", class="chunkID")
preview(chunk1) <- 1:5
resolution(chunk1) <- "RESOLVED"

chunk1

invisible(readline()) ##### [32mAssign Chunk Reference[0m ############################

x <- do.call.chunkRef(what="expm1", chunkArg=chunk1)

invisible(readline()) ##### [32mAssign Chunk Reference with Failure[0m ###############

y <- do.call.chunkRef("as.Date", x)

invisible(readline()) ##### [32mLocal Operations while Chunks Resolve[0m #############

expm1(1:10)

invisible(readline()) ##### [32mPreview of Successful Chunk[0m #######################

x

invisible(readline()) ##### [32mValue of Successful Chunk[0m #########################

do.call.chunkRef("identity", x, assign=FALSE)

invisible(readline()) ##### [32mResolution of Unsuccessful Chunk[0m ##################

resolve(y)
