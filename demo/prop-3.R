source("prop-3-setup")

taxicab <- read.dlcsv(host, file, col.names=names(cols), colClasses=cols)
print(taxicab)
preview(taxicab)
nrow(taxicab)
object.dsize(taxicab)

totaltips <- taxicab$tip_amount
sum(totaltips, na.rm=T)
