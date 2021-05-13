source("prop-3-setup")

taxicab <- read.dlcsv(hosts, files)
print(taxicab)
preview(taxicab)
nrow(taxicab)
object.dsize(taxicab)

isCMT <- taxicab$VendorID == 1L
preview(isCMT)
sum(isCMT, na.rm=T)
