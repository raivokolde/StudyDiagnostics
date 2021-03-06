% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/IncidenceProportion.R
\name{plotIncidenceProportionByYear}
\alias{plotIncidenceProportionByYear}
\title{Plot incidence proportion by year}
\usage{
plotIncidenceProportionByYear(incidenceProportion, fileName = NULL)
}
\arguments{
\item{incidenceProportion}{Incidence proportion time series data for plotting generated using
\code{\link{getIncidenceProportion}} function.}

\item{fileName}{Optional: name of the file where the plot should be saved, for example
'plot.png'. See the function \code{ggsave} in the ggplot2 package for
supported file formats.}
}
\value{
A ggplot object. Use the \code{\link[ggplot2]{ggsave}} function to save to file in a different
format.
}
\description{
Characterizes the incidence proportion of a phenotype as a time series visualization
}
\details{
Generates time series plots of the incidence proportion per 1000 persons of phenotype entry by
year.
}
