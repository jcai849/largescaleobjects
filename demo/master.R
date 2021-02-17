#!/usr/local/bin/Rscript --vanilla

library(largeScaleR)

commsProcess('localhost')
userProcess('localhost')

fileLoc <- tempfile(fileext=".csv")
data <- mtcars
write.csv(data, fileLoc, row.names=FALSE)

x <- read(localCSV(fileLoc), col_types = sapply(data, class))

print(x)
resolve(x)
print(x)
k <- resolve(x$mpg) * resolve(x$cyl)
print(k)
print(resolve(k))
browser()
.Last()
