% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/test_framework.R
\name{listTestRefEntries}
\alias{listTestRefEntries}
\title{List test reference entries.}
\usage{
listTestRefEntries(conn.id, limit = 0, pkgName = NULL)
}
\arguments{
\item{conn.id}{A valid Biodb connector ID.}

\item{limit}{The maximum number of entries to retrieve.}

\item{pkgName}{The name of the}
}
\value{
A list of entry IDs.
}
\description{
Lists the reference entries in the test folder for a specified connector.
The test reference files must be in \verb{<pkg>/inst/testref/} folder and
their names must match \verb{entry-<database_name>-<entry_accession>.json} (e.g.:
\verb{entry-comp.csv.file-1018.json}).
}
\examples{
# List IDs of test reference entries:
biodb::listTestRefEntries('comp.csv.file', pkgName='biodb')

}
