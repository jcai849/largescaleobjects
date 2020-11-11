distObj::beginNZSA2020Demo()

flights <- read.csv(file	= fileNames,
		    header	= I(FALSE),
		    col.names	= I(names(cols)),
		    colClasses	= I(as.vector(cols)))

sanOrig <- flights$Origin == "SAN"

sanOrigCounts <- sum(sanOrig, na.rm=TRUE)

origTab <- table(flights$Origin, flights$DayOfWeek)
chisq.test(origTab["SAN",], origTab["LAX",])

killAt(flights)
clear()
