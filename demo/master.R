library(largeScaleR)

commsProcess('localhost')
userProcess('localhost')

fileLoc <- tempfile(fileext=".csv")
data <- mtcars
write.csv(data, fileLoc, row.names=FALSE)

x <- read(localCSV(fileLoc), col_types = sapply(data, class),
        max.size=3000074)
print(x)
print(x$mpg * x$cyl)
