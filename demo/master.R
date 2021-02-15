#!/usr/local/bin/Rscript --vanilla

library(largeScaleR)

commsProcess('localhost')
userProcess('localhost')

fileLoc <- tempfile(fileext=".csv")
data <- mtcars
write.csv(data, fileLoc, row.names=FALSE)

x <- read(localCSV(fileLoc), col_types = sapply(data, class))

debug(largeScaleR:::access)

print(x)
print(x$mpg * x$cyl)

.Last()
