#' @rdname importfunctions
#' @export
what <- function(.from, ...,
                 .library = .libPaths()[1L], .directory=".",
                 .chdir = TRUE, .character_only = FALSE, .S3 = FALSE)
{
  # Capture the call and check that it is valid.
  cl <- match.call()
  if (!identical(cl[[1L]], call( "::", quote(import), quote(what))))
    stop("Use `import::what()`when listing objects available for import",
         call. = FALSE)

  # Ensure the needed arguments are provided.
  if (missing(.from))
    stop("Argument `.from` must be specified.", call. = FALSE)

  # ... is included to prevent unnamed arguments apart from `.from`,
  # but including anything there is an error.
  dots <- as.list(substitute(list(...)))[-1L]
  if (length(dots) > 0L) {
    stop("Unexpected arguments passed via `...`")
  }

  # Create cl which captures the call
  cl <- match.call()

  # If no symbols were supplied in `...`, list everything
  dots <- as.list(substitute(list(...)))[-1L]
  if (length(dots) == 0L) cl[[".all"]] <- TRUE

  # Rewrite the call to import::from syntax and evaluate in new frame.
  tmp_env <- new.env(parent = emptyenv())
  cl[[1L]][[3L]] <- quote(from)
  cl[[".into"]] <- quote(tmp_env)        # import into our temporary env

  # Evaluate in an environment where `tmp_env` is bound, with the parent frame
  # as enclosure. This preserves parent lookup while exposing `tmp_env`.
  eval(cl, envir = list2env(list(tmp_env = tmp_env), parent = parent.frame()))

  ls(tmp_env)
}
