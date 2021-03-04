# prepare csv

iris$Species <- as.character(iris$Species)
df <- iris

fileLoc <- tempfile(pattern="largeScaleRtest", fileext=".csv")
write.table(iris, fileLoc,, F, ",",, "",,F, F)
fileLoc2 <- tempfile(pattern="largeScaleRtest", fileext=".csv")
write.table(iris, fileLoc2,, F, ",",, "",,F, T)
cols <- sapply(df, class)

##

library(largeScaleR)
init("config")

## no header

CSVfile <- localCSV(loc=fileLoc, 
		    colTypes=cols,
		    header=FALSE, 
		    quote="")
distDF <- read(CSVfile)
resolve(distDF)
undistDF <- unstub(distDF)

stopifnot(identical(undistDF, iris))

## header

CSVfile <- localCSV(loc=fileLoc2, 
		    colTypes=cols,
		    header=TRUE, 
		    quote="")
distDF <- read(CSVfile)
resolve(distDF)
undistDF <- unstub(distDF)

stopifnot(identical(undistDF, iris))
