% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fcts_biodb.R
\name{logInfo0}
\alias{logInfo0}
\title{Log information message.}
\usage{
logInfo0(...)
}
\arguments{
\item{...}{Values to be passed to paste0().}
}
\value{
Nothing.
}
\description{
Logs an information level message with biodb logger, using paste0().
}
\examples{
# Logs an info message:
biodb::logInfo0('Index is ', 10, '.')

}
