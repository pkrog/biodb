% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fcts_biodb.R
\name{logTrace}
\alias{logTrace}
\title{Log trace message.}
\usage{
logTrace(...)
}
\arguments{
\item{...}{Values to be passed to sprintf().}
}
\value{
Nothing.
}
\description{
Logs a trace level message with biodb logger.
}
\examples{
# Logs a trace message:
biodb::logTrace('Index is \%d.', 10)

}
