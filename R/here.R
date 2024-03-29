#' @rdname importfunctions
#' @export
here <- function(.from, ...,
                 .library = .libPaths()[1L], .directory=".",
                 .all=(length(.except) > 0), .except=character(),
                 .chdir = TRUE, .character_only = FALSE, .S3 = FALSE)
{
  # Capture the call and check that it is valid.
  cl <- match.call()
  if (!identical(cl[[1L]], call( "::", quote(import), quote(here))) &&
      !identical(cl[[1L]], call(":::", quote(import), quote(here))))
    stop("Use `import::` or `import:::` when importing objects.", call. = FALSE)

  # Ensure the needed arguments are provided.
  if (missing(.from))
    stop("Argument `.from` must be specified.", call. = FALSE)

  # Rewrite the call to import::from syntax and evaluate in parent frame.
  cl <- match.call()
  cl[[1L]][[3L]] <- quote(from)
  cl[[".into"]] <- quote({environment()})

  eval.parent(cl)
}
