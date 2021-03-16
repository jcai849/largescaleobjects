library(largeScaleR)

init("config")

# make data

nCases <- rbinom(1E7, 20, 0.3)
COVID <- data.frame(date = as.character(sample(seq(as.Date("2020-01-01"),
						   Sys.Date(), by="day"), 1E7,
					       replace=TRUE)),
                   loc = sample(replicate(100, paste0(sample(letters, 3), collapse="")), 1E7, replace=TRUE),
                   lockdowns = rbinom(1E7, 4, 0.2))
cols <- sapply(COVID, class)
fileLoc <- tempfile(pattern="largeScaleR", fileext=".csv")
write.table(COVID, fileLoc,, F, ",",, "",,F,F)
CSVfile <- localCSV(loc=fileLoc, colTypes=cols,header=FALSE,quote="")

# distribute data
distCOVID <- read(CSVfile, max.size=10*1024^2) #10Mb
cache(distCOVID)
distnCases <- stub(nCases, 10)
cache(distnCases)
