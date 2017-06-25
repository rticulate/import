#' Safe Assignment
#'
#' Wrapper for \code{assign} which will not allow assigning a name to a
#' different value in the given environment.
#'
#' @param x A variable name. See \link[base]{\code{assign}}.
#' @param value The value. See \link[base]{\code{assign}}.
#' @param pos Where to do assignment. See \link[base]{\code{assign}}.
#' @param envir The environment. See \link[base]{\code{assign}}.
#' @param inherits Should the enclosing environment be inspected? See \code{\link[base]{assign}}.
#'
#' @noRd
safe_assign <- function(x, value, pos = -1, envir = as.environment(pos), inherits = FALSE)
{
  if (x %in% ls(envir, all.names = TRUE) &&
     !identical(environment(envir[[x]]), environment(value)))
    stop("Cannot assign name to different value in the given environment. Name already in use.",
         call. = FALSE)

  assign(x, value, pos, envir, inherits)
}
