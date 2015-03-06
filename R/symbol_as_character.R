#' Convert a possible symbol to character.
#'
#' @param symbol A symbol or character (of length one)
#' @return character
symbol_as_character <- function(symbol)
{
  if (is.symbol(symbol) ||
     (is.character(symbol) && length(symbol) == 1L))
    as.character(symbol)
  else
    stop(sprintf("%s is not a valid symbol.",
                 paste(as.character(symbol), collapse = " ")),
         call. = FALSE)
}

