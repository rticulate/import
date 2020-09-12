## ---- eval = FALSE------------------------------------------------------------
#  library(PackageA)
#  library(PackageB)
#  
#  value1 <- function_a(...) # Supposedly this comes from PackageA,
#  value2 <- function_b(...) # and this from PackageB, but who knows?!
#  ...

## ---- eval = FALSE------------------------------------------------------------
#  function_a <- PackageA::function_a
#  function_b <- PackageB::function_b

## ---- eval=FALSE--------------------------------------------------------------
#  import::from(psych, geometric.mean, harmonic.mean)
#  geometric.mean(trees$Volume)

## ---- eval=FALSE--------------------------------------------------------------
#  import::from(dplyr, select, arrange, keep_when = filter)
#  keep_when(mtcars, hp>250)

## ---- eval=FALSE--------------------------------------------------------------
#  import::from(dplyr, keep_when = filter, .all=TRUE)

## ---- eval=FALSE--------------------------------------------------------------
#  import::from(dplyr, .except=c("filter", "lag"))

## ---- eval = FALSE------------------------------------------------------------
#  import::from(magrittr, "%>%")
#  import::from(dplyr, starwars, select, mutate, keep_when = filter)
#  import::from(tidyr, unnest)
#  import::from(broom, tidy)
#  
#  ready_data <-
#    starwars %>%
#    keep_when(mass < 100) %>%
#    select(name, height, mass, films) %>%
#    unnest(films) %>%
#    mutate( log_mass = log(mass), films=factor(films))
#  
#  linear_model <-
#    lm(log_mass ~ height + films, data = ready_data) %>%
#    tidy

## ---- eval=FALSE--------------------------------------------------------------
#  import::from(sequence_module.R, fibonacci, square, triangular)

## ---- eval=FALSE--------------------------------------------------------------
#  import::from(sequence_module.R, fib=fibonacci, .except="square")

## ---- eval=FALSE--------------------------------------------------------------
#  ## Do not use library() inside a module. This results in a warning,
#  ## and functions relying on ggplot2 will not work.
#  #library(ggplot2)
#  
#  ## This is also not recommended, because it is not clear wether recursively
#  ## imported functions should be available after the module is imported
#  #import::here(qplot, .from = ggplot2)
#  
#  ## This is the recommended way to recursively import functions on which
#  ## module functions depend. The qplot function will be available to
#  ## module functions, but will not itself be available after import
#  import::here(qplot, .from = ggplot2)
#  
#  ## Note this operator overload is not something you want to `source`!
#  `+` <- function(e1, e2)
#    paste(e1, e2)
#  
#  ## Some function relying on the above overload:
#  a <- function(s1, s2)
#    s1 + rep(s2, 3)
#  
#  ## Another value.
#  b <- head(iris, 10)
#  
#  ## A value created using a recursively imported function
#  p <- qplot(Sepal.Length, Sepal.Width, data = iris, color = Species)
#  
#  ## A function relying on a function exposed through attachment:
#  plot_it <- function()
#    qplot(Sepal.Length, Sepal.Width, data = iris, color = Species)

## ---- eval=FALSE--------------------------------------------------------------
#  import::from(some_module.R, a, b, p, plot_it)
#  
#  ## Works:
#  a("cool", "import")
#  
#  ## The `+` is not affecting anything here, so this won't work:
#  # "cool" + "import"
#  
#  # Works:
#  b
#  p
#  plot_it()

## ---- eval=FALSE--------------------------------------------------------------
#  # File: foo.R
#  # Desc: Functionality related to foos.
#  # Imports from other_resources.R
#  # When recursively importing from another module or package for use by
#  # your module functions, you should always use import::here() rather
#  # than import::from() or library()
#  import::here(fun_a, fun_b, .from = "other_resources.R")
#  
#  internal_fun <- function(...) ...
#  
#  fun_c <- function(...)
#  {
#    ...
#    a <- fun_a(...)
#    i <- internal_fun(...)
#    ...
#  }
#  
#  fun_d <- function(...) ...

## ---- eval = FALSE------------------------------------------------------------
#  # File: bar.R
#  # Desc: Functionality related to bars.
#  # Imports from foo.R
#  import::here(fun_c, .from = "foo.R")
#  ...

## ---- eval = FALSE------------------------------------------------------------
#  import::from(magrittr, "%>%", "%$%", .into = "operators")
#  import::from(dplyr, arrange, .into = "datatools")

## ---- eval = FALSE------------------------------------------------------------
#  import::into("operators", "%>%", "%$%", .from = magrittr)
#  import::into("datatools", arrange, .from = dplyr)

## ---- eval = FALSE------------------------------------------------------------
#  import::into("operators", "%>%", "%$%", .from = magrittr)
#  import::into("datatools", arrange, .from = dplyr)

## ---- eval = FALSE------------------------------------------------------------
#  # Import into the local environment
#  import::into({environment()}, "%>%", .from = magrittr)
#  
#  # Import ihnto the global environment
#  import::into({.GlobalEnv}, "%>%", "%$%", .from = magrittr)
#  
#  # Import into a new environment, mainly useful for python-style imports
#  # (see below)
#  x = import::into({new.env()}, "%<>%", .from = magrittr)

## ---- eval = FALSE------------------------------------------------------------
#  objects <- c("tidy", "glance", "augment")
#  import::from("broom", objects, .character_only=TRUE)

## ---- eval = FALSE------------------------------------------------------------
#  objects <- setdiff(getNamespaceExports("dplyr"), c("filter","lag"))
#  import::from("dplyr", objects, .character_only=TRUE)

## ---- eval = FALSE------------------------------------------------------------
#  mymodule <- file.path(mypath,"module.R")
#  import::from(mymodule, "myfunction", .character_only=TRUE)

## ---- eval = FALSE------------------------------------------------------------
#  import::from(here::here("src/utils/module.R")), "myfunction", .character_only=TRUE)

## ---- eval = FALSE------------------------------------------------------------
#  import::from(module.R, "myfunction", here::here("src/utils"))

## ---- eval = FALSE------------------------------------------------------------
#  url <- "https://gist.githubusercontent.com/noamross/378884a472b5ef58c6cf/raw/1cd3a47158427ef7e2faa897d32821f14fa19bfd/test.R"
#  import::from(pins::pin(url), "myfunc", .character_only=TRUE)
#  myfunc(3)
#  #> [1] 4

## ---- eval = FALSE------------------------------------------------------------
#  # Import into a new namespace, use $ to access
#  td <- import::from(tidyr, spread, pivot_wider, .into={new.env()})
#  dp <- import::from(dplyr, .all=TRUE, .into={new.env()})
#  dp$select(head(cars),dist)
#  #>   dist
#  #> 1    2
#  #> 2   10
#  #> 3    4
#  #> 4   22
#  #> 5   16
#  #> 6   10
#  
#  # Note that functions are not visible without dp$ prefix
#  select(head(cars),dist)
#  #> Error in select(head(cars), dist): could not find function "select"

