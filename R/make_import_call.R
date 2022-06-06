#' Make an import call object.
#'
#' The import call constructed by this function can be evaluated with `eval` to
#' perform the actual import.
#'
#' @param params A list of parameters to substitute in the call.
#' @param exports_only A logical indicating whether only exported objects are
#'   allowed.
#'
#' @return A call object.
#'
#' @md
#' @noRd
make_import_call <- function(params, exports_only)
{
  cl <-
    if (exports_only)
       substitute(safe_assign(new, base::getExportedValue(nm, ns = ns), pos = pos),
                  params)
    else
       substitute(safe_assign(new, base::get(nm, envir = ns, inherits = inh), pos = pos),
                  params)

  cl[[1]] <- safe_assign

  cl
}
