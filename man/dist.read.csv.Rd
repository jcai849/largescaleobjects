\name{dist.read.csv}
\alias{dist.read.csv}
\title{Read in distributed csv files}
\description{
	Looks inside the file locations and produces a distributed object,
	returning a distributed object reference.
}
\usage{
dist.read.csv(files)
}
\arguments{
  \item{files}{A character vector of file locations
  }
}
\details{
	Looks inside the file locations and produces a distributed object,
	returning a distributed object reference.
}
\value{
	a distributed.data.frame
}
\author{
	Jason Cairns
}

\seealso{
\code{\link{read.csv}}
}
\keyword{IO}% use one of  RShowDoc("KEYWORDS")
\keyword{file}% __ONLY ONE__ keyword per line
