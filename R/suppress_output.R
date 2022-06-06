#' Suppress the output of a command
#'
#' This function simply calls [`base::suppressPackageStartupMessages()`].
#'
#' @param e An expression that is passed to `suppressPackageStartupMessages`
#'
#' @md
#' @noRd
suppress_output <- function(e) suppressPackageStartupMessages(e)
