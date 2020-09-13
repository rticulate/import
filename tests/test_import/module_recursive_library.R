# Import utility function or package using import::here() is the recommended usage
library(knitr)

standalone_fun = function(text){
  print(text)
}

dependent_fun = function(text){
  normal_print(text)
}
