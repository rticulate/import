# a sample generic with two different methods (that should behave differently)
test_fun <- function(x){
  UseMethod("test_fun", x)
}

test_fun.character <- function(x){
  structure("character", class = "test_class")
}


test_fun.numeric <- function(x){
  structure("numeric", class = "test_class")
}

# a method for existing (base) generic.
print.test_class <- function(x){
  print(as.character(x))
}

# a method for class with dot in name
test_fun.data.frame = function(x){
    structure("data.frame", class = "test_class")
    }
