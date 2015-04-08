#' Make an import call object.
#'
#' The import call constructed by this function can be evaluated with
#' \code{eval} to perform the actual import.
#'
#' @param params list of parameters to substitute in the call.
#' @param exports_only logical indicating whether only exported objects are
#'   allowed.
#'
#' @return A call object.
make_import_call <- function(params, exports_only)
{
  if (exports_only)
    substitute(assign(new, getExportedValue(nm, ns = ns), pos = pos),
               params)
  else
    substitute(assign(new, get(nm, envir = ns, inherits = inh), pos = pos),
               params)
}
