\name{getCluster}
\alias{getCluster}
\title{Get Attributes of the Current Cluster}
\description{
	Use to query attributes of the cluster, internally looking at the
	cluster table, and return the formatted results.
}
\usage{
getCluster(...)
}
\arguments{
  \item{...}{Characters specifying the objects of query, as specified in details}
}
\details{
	The query is composed of a series of specific character values used to
	query their corresponding components in the system. Values that can be
	taken by the arguments include the following:
	\describe{
		\item{chunk}{The chunk ID's in the system}
		\item{size}{The sizes of each chunk}
		\item{node}{The node IDs}
		\item{links}{The number of chunks associated with each node}
		\item{host}{The hosts in the system}
		\item{connection}{The RSclient connections to each node}
	}
}
\value{
	A data frame with columns taking the names of the attributes queried
	for.
}
\author{
	Jason Cairns
}

\examples{
\dontrun{getCluster("host", "size")}
}
\keyword{environment}% use one of  RShowDoc("KEYWORDS")
\keyword{utilities}% __ONLY ONE__ keyword per line
