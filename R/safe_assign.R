#' Safe Assignment
#'
#' Wrapper for \code{assign} which will not allow assigning a name to a
#' different value in the given environment. See [`base::assign()`] for
#' information about the role of each parameter.
#'
#' @param x A variable name.
#' @param value The value.
#' @param pos Where to do assignment.
#' @param envir The environment.
#' @param inherits Should the enclosing environment be inspected?
#'
#' @md
#' @noRd
safe_assign <- function(x, value, pos = -1, envir = as.environment(pos), inherits = FALSE)
{
  if (x %in% ls(envir, all.names = TRUE) &&
     !identical(environment(envir[[x]]), environment(value)))
    stop("Cannot assign name to different value in the given environment. Name already in use.",
         call. = FALSE)

  assign(x, value, pos, envir, inherits)
}
