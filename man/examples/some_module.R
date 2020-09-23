## Do not use library() inside a module. This results in a warning,
## and functions relying on ggplot2 will not work.
#library(ggplot2)

## This is also not recommended, because it is not clear wether recursively
## imported functions should be available after the module is imported
#import::here(qplot, .from = ggplot2)

## This is the recommended way to recursively import functions on which
## module functions depend. The qplot function will be available to
## module functions, but will not itself be available after import
import::here(qplot, .from = ggplot2)

## Note this operator overload is not something you want to `source`!
`+` <- function(e1, e2)
  paste(e1, e2)

## Some function relying on the above overload:
a <- function(s1, s2)
  s1 + rep(s2, 3)

## Another value.
b <- head(iris, 10)

## A value created using a recursively imported function
p <- qplot(Sepal.Length, Sepal.Width, data = iris, color = Species)

## A function relying on a function exposed through attachment:
plot_it <- function()
  qplot(Sepal.Length, Sepal.Width, data = iris, color = Species)
