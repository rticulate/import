#' Detect bad recursion in function call
#'
#' Examines the stack trace that is passed as an argument to determine
#' if import::*() has been called recursively in a way that is not
#' allowed (i.e. bad).
#'
#' Any recursive use of import::*() within a module that is itself being
#' imported should only be done with import::here(). Never with
#' import::from() or import::into()
#'
#' A bad recursion is a recursion in which the
#'
#' @param stack_trace A list object containing the value of a \code{.traceback()} call
#' @return logical indicating whether a bad recursion call was detected
#'
#' @noRd
detect_bad_recursion <- function(stack_trace) {

  # Extract all lines correxponding to calls to import::*
  x <- grep("^import::", unlist(stack_trace), value = TRUE)

  # If more than one line starts with import:::?from, we are inside
  # a recursive call. That is OK, as long as the last call originates+
  # in a call to import here (i.e. the second element in the vector
  # starts with import:::?here)
  if ( length(grep("^import:::?from", x, value=TRUE)) > 1 ) {
    if ( !grepl("^import:::?here", x[2])) {
      # Ouch, we have detected a bad recursion
      return(TRUE)
    }
  }
  return(FALSE)
}
