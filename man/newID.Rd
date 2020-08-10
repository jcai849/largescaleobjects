\name{newID}
\alias{newNodeID}
\alias{newChunkID}
\title{Generate a New ID}
\description{
	Generate a unique new ID for nodes or chunks.
}
\usage{
newNodeID()
newChunkID()
}
\details{
	Increments the internal cluster table node/chunk counter, and returns
	the value, for the purpose of unique identification of a new
	node/chunk.
}
\value{
	Unique integer serving as a unique node/chunk identifier.
}
\author{
	Jason Cairns
}
\keyword{environment}% use one of  RShowDoc("KEYWORDS")
\keyword{utilities}% __ONLY ONE__ keyword per line
