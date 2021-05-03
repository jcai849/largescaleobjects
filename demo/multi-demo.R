library(largeScaleR)
options(keep.source=TRUE,
	keep.source.pkgs=TRUE)

init("config-multi")

# make data
nrow <- 1E5
nCases <- rbinom(1E5, 20, 0.3)
COVID <- data.frame(date = as.character(sample(seq(as.Date("2020-01-01"),
						   Sys.Date(), by="day"), 1E5,
					       replace=TRUE)),
                   loc = sample(replicate(100, paste0(sample(letters, 3), collapse="")), 1E5, replace=TRUE),
                   lockdowns = rbinom(1E5, 4, 0.2))
cols <- sapply(COVID, class)
fileLoc <- tempfile(pattern="largeScaleR", fileext=".csv")
write.table(COVID, fileLoc,, F, ",",, "",,F,F)
CSVfile <- localCSV(loc=fileLoc, colTypes=cols,header=FALSE,quote="")

# distribute data
distCOVID <- read(CSVfile, max.size=100*1024) #100Kb
distnCases <- distribute(nCases, 18)
k=distCOVID$lockdowns * distnCases
preview(k)
