#' Process a symbol list provided passed as ellipses
#'
#' This function is used within a function that receives dot-arguments,
#' and will create a named character vector. It ensures that all
#' entries are named, and will use the value as name when it is missing.
#'
#' @param ... dot arguments as passed to
#' @return A named character vector.
symbol_list <- function(...)
{
  dots    <- eval(substitute(alist(...)), parent.frame(), parent.frame())
  names   <- names(dots)
  unnamed <- if (is.null(names)) 1:length(dots) else which(names == "")
  dots    <- vapply(dots, symbol_as_character, character(1))

  names(dots)[unnamed] <- dots[unnamed]

  dots
}
