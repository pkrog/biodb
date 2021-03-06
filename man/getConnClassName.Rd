% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fcts_biodb.R
\name{getConnClassName}
\alias{getConnClassName}
\title{Get connector class name.}
\usage{
getConnClassName(connName)
}
\arguments{
\item{connName}{A connector name (e.g.: "mass.csv.file").}
}
\value{
The name of the corresponding connector class (e.g.:
"MassCsvFileConn").
}
\description{
Gets the name of the connector class corresponding to a connector.
}
\examples{
biodb::getConnClassName('foo.db')

}
