#' Process a symbol list provided passed as ellipses
#'
#' This function is used within a function that receives dot-arguments,
#' and will create a named character vector. It ensures that all
#' entries are named, and will use the value as name when it is missing.
#'
#' @param ... dot arguments as passed to
#' @param .character_only logical indicating whether \code{...} can be assumed
#'   to be charater strings.
#'
#' @noRd
#' @return A named character vector.
symbol_list <- function(..., .character_only = FALSE, .all=FALSE)
{
  if (isTRUE(.character_only)) {
    dots <- unlist(list(...))
  } else {
    dots    <- eval(substitute(alist(...)), parent.frame(), parent.frame())
  }

  if (length(dots)==0) {
    # If .all was true, empty dots should no longer error
    return(character())
  }

  names   <- names(dots)
  unnamed <- if (is.null(names)) 1:length(dots) else which(names == "")
  dots    <- vapply(dots, symbol_as_character, character(1))

  names(dots)[unnamed] <- dots[unnamed]

  dots
}
