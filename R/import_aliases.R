#' Environment with Mappings from Import- and Original Names
#'
#' This is used to redirect documentation requests on imported names.
#'
#' @md
#' @noRd
import_aliases <- new.env()


`?redirect` <- function(e1, e2)
{
  redirect <- FALSE
  cl <- match.call()

  sym <- substitute(e1)
  if  (missing(e2) &&
      (is.symbol(sym) || (is.character(sym) && length(sym) == 1L))) {
    sym <- import_aliases[[symbol_as_character(sym)]]
    if (!is.null(sym)) {

      cl[[2L]] <- sym
      redirect <- TRUE
      msg <- paste0("import: showing documentation for ",
                    deparse(sym, nlines = 1))
      message(msg)
    }
  }

  if (!redirect) {
    cl[[1]] <- call("::", "utils", "?")
  }

  eval(cl, parent.frame(), parent.frame())
}
