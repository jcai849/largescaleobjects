source("prop-3-setup")
taxicab <- read.dlcsv(hosts, files)
print(taxicab)
preview(taxicab)
nrow(taxicab)
desc(taxicab)
host(taxicab)

isCMT <- taxicab$VendorID == 1L
print(isCMT)
preview(isCMT)
sum(isCMT, na.rm=T)
CMT <- subset(taxicab, isCMT)
length(CMT)

passengertip <- table(CMT$passenger_count, CMT$tip_amount)
print(passengertip)
col(passengertip)
