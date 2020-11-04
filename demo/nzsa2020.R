distObj::beginNZSA2020Demo()

chunk(fileNames) <- chunk(fileNames)[seq(1,32,4)]

flights <- do.call.distObjRef("read.csv", 
			      list(file		= fileNames,
				   header	= I(FALSE),
				   col.names	= I(names(cols)),
				   colClasses	= I(as.vector(cols))))

#sanOrig <- flights$Origin == "SAN"
#
#sanOrigCounts <- sum(sanOrig)
#
## table
#
#table(flights$Origin, flights$Dest)
#
## exit
#
#killAt(flights)
#clear()
