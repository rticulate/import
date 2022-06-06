#' Script Module Environment.
#'
#' In addition to importing from packages, `import` allows imports from `.R`
#' scripts (serving as modules). The scripts will be sourced into this
#' environment, from which values can be fetcthed.
#'
#' @md
#' @noRd
scripts <- new.env()
