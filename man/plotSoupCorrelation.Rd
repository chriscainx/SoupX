% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotFunctions.R
\name{plotSoupCorrelation}
\alias{plotSoupCorrelation}
\title{Plot correlation of expression profiles of soup and aggregated cells}
\usage{
plotSoupCorrelation(sc, channelName)
}
\arguments{
\item{sc}{A SoupChannel or SoupChannelList object.}

\item{channelName}{The name of the channel to use if \code{sc} is a \code{SoupChannelList}}
}
\value{
A ggplot2 object containing the plot.
}
\description{
Calculates an expression profile by aggregating counts across all cells and plots this (on a log10 scale) against the expression profile of the soup.
}
