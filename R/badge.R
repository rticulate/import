
#' Add a lifecycle badge to html help versions only
#'
#' @param stage A character representing the stage
#' @return Badge code appropriate for inclusion in .Rd file
#'
#' @noRd
badge <- function(stage)
{
  # Utility function for capital case
  upcase1 <- function (x)
  {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    x
  }

  # Check arguments
  stages <- c("experimental", "stable", "superseded", "deprecated")
  stopifnot(stage %in% stages)

  # Construct .Rd code
  url <- paste0("https://lifecycle.r-lib.org/articles/stages.html#", stage)
  html <- sprintf("\\href{%s}{\\figure{%s}{options: alt='[%s]'}}",
    url, file.path(sprintf("lifecycle-%s.svg", stage)), upcase1(stage))
  text <- sprintf("\\strong{[%s]}", upcase1(stage))
  sprintf("\\ifelse{html}{%s}{%s}", html, text)
}
