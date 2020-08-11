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
	\code{files} takes a similar syntax to \code{scp}, though without user
	or port specifications. The format must be of the form,
	\code{host:filepath}, using absolute file paths.
	The files form rows of the distributed csv in the same order given in
	the \code{files} argument.
}
\note{
	Due to the nature of such large data, it is imperative to ensure the
	highest levels of accuracy in the constituent files; make sure that all
	columns are the same, no headers are included in the files, and that
	colClasses are defined.
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
\examples{
\dontrun{
	dist.read.csv(c("host1:/file/path/here.csv", 
			"host2:/file/path/here2.csv"))
}
}
\keyword{IO}% use one of  RShowDoc("KEYWORDS")
\keyword{file}% __ONLY ONE__ keyword per line
