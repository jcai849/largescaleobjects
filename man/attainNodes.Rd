\name{attainNodes}
\alias{attainNodes}
\title{Intelligently Establish or Retrieve Nodes from a Vector of Hosts}
\description{
	Given a vector of host names, retrieve existing connections to the
	hosts, as well as create new connections to those which haven't been
	initialised yet.
}
\usage{
attainNodes(hostNames)
}
\arguments{
  \item{hostNames}{A character vector of host names}
}
\details{
	Individual hosts can and should repeat if multiple connections to the
	same host are desired.
}
\value{
	integer vector of node ID's
}
\author{
	Jason Cairns
}

\seealso{
\code{\link{newConnection}}
}
\keyword{IO}
\keyword{connection}
