distObj::beginNZSA2020Demo()

flights <- do.call.distObjRef("read.csv", 
			      list(file		= fileNames,
				   header	= FALSE,
				   col.names	= names(cols),
				   colClasses	= as.vector(cols)))

# anonfun
sanOrig <- flights$Origin

sanOrigCounts <- sum(sanOrig)

# table

table(flights$Origin, flights$Dest)

# lm

do.call.distObjRef(function(x) q("no"),
		   list(x = flights))
