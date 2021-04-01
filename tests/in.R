library(largeScaleR)
init("config")

# single chunk
## prepare df
iris$Species <- as.character(iris$Species)
df <- iris
cols <- sapply(df, class)

## no header
### prepare csv
fileLoc <- tempfile(pattern="largeScaleRtest", fileext=".csv")
write.table(df, fileLoc,, F, ",",, "",,F, F)

### test
CSVfile <- localCSV(loc=fileLoc, 
		    colTypes=cols,
		    header=FALSE, 
		    quote="")
distDF <- read(CSVfile)
undistDF <- unstub(distDF)

stopifnot(identical(undistDF, df))

## header
### prepare csv
fileLoc2 <- tempfile(pattern="largeScaleRtest", fileext=".csv")
write.table(df, fileLoc2,, F, ",",, "",,F, T)

### test
CSVfile <- localCSV(loc=fileLoc2, 
		    colTypes=cols,
		    header=TRUE, 
		    quote="")
distDF <- read(CSVfile)
undistDF <- unstub(distDF)

stopifnot(identical(undistDF, df))

# multiple chunks
## header
### prepare csv
df <- data.frame(x=rnorm(1E5), y=rnorm(1E5), z=rnorm(1E5))
fileLoc3 <- tempfile(pattern="largeScaleRtest", fileext=".csv")
write.table(df, fileLoc3,, F, ",",, "",,F, T)
cols <- sapply(df, class)

### test
CSVfile <- localCSV(loc=fileLoc3, 
		    colTypes=cols,
		    header=TRUE, 
		    quote="")
distDF <- read(CSVfile, max.size=1024^2)
undistDF <- unstub(distDF)
stopifnot(all.equal(undistDF, df))

## no header
### prepare csv
fileLoc4 <- tempfile(pattern="largeScaleRtest", fileext=".csv")
write.table(df, fileLoc4,, F, ",",, "",,F, F)

### test
CSVfile <- localCSV(loc=fileLoc4, 
		    colTypes=cols,
		    header=FALSE, 
		    quote="")
distDF <- read(CSVfile, max.size=1024^2)
undistDF <- unstub(distDF)
stopifnot(all.equal(undistDF, df))
final(1)
