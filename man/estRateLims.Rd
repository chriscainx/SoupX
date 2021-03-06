% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estRateLims.R
\name{estRateLims}
\alias{estRateLims}
\title{Calculate limits on estimated binomial rate from data}
\usage{
estRateLims(x, n, conf = 0.95, noms = NULL, sort = FALSE)
}
\arguments{
\item{x}{Number of positive observations.}

\item{n}{Out of this many.}

\item{conf}{Confidence interval}

\item{noms}{Row names to give to output.  If NULL, set to names(x).}

\item{sort}{Should we sort the output by est?}
}
\value{
A data.frame giving estimated rate (x/n) and the 95% confidence limits.
}
\description{
Internal use only.  Gets 95% confidence limits on an observation of x counts for something out of a total of n observations.
}
