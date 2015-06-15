![Alt text](./import.png?raw=true "import logo")
# An Import Mechanism For R

## Motivation
The typical way of using functionality exposed by a package in R scripts is to 
load (and attach) the entire package with `library` (or `require`). This can 
have the **undesirable effect of masking objects** in the user's search path 
and can also make it difficult and **confusing to identify** what functionality 
comes from which package when using several `library` statements.

An alternative is to import a single object from a package, say `object <-
package::object`. The downside of this approach is that the object is **placed 
in the user's global work space**, rather than being encapsulated somewhere else
in the search path (when using `library` to load `pkg`, a namespace `package:pkg` 
will be attached in the search path which will contain the exported functions 
from `pkg`). Another minor point is that one can **only import one object at a 
time** using this approach.

The `import` package provides a simple alternative to importing and is inspired
in part by Python's `from some_module import some_function` syntax, and will
solve the two issues raised above. It is also similar to `roxygen2`s 
`@importFrom package function1 function2` for packages. While `import` will 
also work for package development, it is meant for `R` scripts.

In addition to being able to import objects from packages, `import` also allows
you to import objects in *scripts* (i.e. a kind of *module*). This allows
a simple way to distribute and use functionality without the need to write
a full package. One example is a Shiny app, where one can place definitions 
in a script and import only the needed objects where they are used. This 
avoids workspace clutter and name clashes. For more details see below.

## Installation and usage 

To install `import` from CRAN:
```R
install.packages("import")
```

You can also install `import` from GitHub using `devtools`:

```R
devtools::install_github("smbache/import")
```

The `import` package is named to **make usage expressive** without having to 
load the package using `library`. A basic example, which imports a few functions
from the `dplyr` package is:

```R
import::from(dplyr, select, arrange, keep_when = filter)
```

This does pretty much what it says: three functions are imported from `dplyr`,
two of which will keep their original name, and one which is renamed, e.g. to
avoid name clash with `stats::filter`. The imported objects are placed in a
separate entity in the search path (@lionel- suggests naming them "pied-à-terres", 
meaning living units some distance away from primary residence), which by 
default is named "imports". It is therefore also easy to get rid of them again 
with `detach("imports")`. The main point is that it is **clear which functions 
will be used and where they come from**. It's noteworthy that there is nothing 
special going on: the `import::from` function is only a convenient wrapper 
around `getExportedValue` (as is `::` itself) and `assign`. To import 
non-exported objects one must use triple-colon syntax: `import:::from(pkg, obj)`.
If any of the `import` functions are called regularly, i.e. without preceding
`import::` or `import:::`, an error is raised. If `import` is attached, a 
startup message will inform that `import` *should not* be attached.

One can also specify which names to use in the search path and use several to 
group imports:

```R
import::from(magrittr, "%>%", "%$%", .into = "operators") 
import::from(dplyr, arrange, .into = "datatools")
```

If using pied-à-terres actively, one might prefer the alternative syntax 
(which does the same but reverses the argument order):

```R
import::into("operators", "%>%", "%$%", .from = magrittr)
import::into("datatools", arrange, .from = dplyr)
```
If it is desired to place imported objects in the current environment, 
then `import::here` is a short-hand function that sets `.into = ""`.

In the examples above most arguments are provided unquoted. A more unambiguous
alternative is to quote the inputs, e.g. 

```R
import::from("ggplot2", "qplot")
```

## Specifying a library

The `import` package will by default only use the latest specified library
(i.e. the result of `.libPaths()[1L]`). It is possible to specify a different
library using the `.library` argument in any of the `import` functions.
One import call can only use *one* library so there will not be ambiguity
as to where imports come from.

## Using .R scripts as "modules" (currently only in GitHub version)

The `import` package allows for importing objects defined in script files,
which we will here refer to as "modules".
The module will be fully evaluated by `import` when an import is requested, 
after which objects such as functions or data can be imported. 
Such modules should be side-effect free, but this is
not enforced. Attachments are detached (e.g. packages attached by `library`)
but loaded namespaces remain loaded. This means that *values* created 
by functions in an attached namespace will work with `import`, but 
functions to be exported *should not* rely on such functions (use function
importing in the modules instead).

If a module is modified, `import` will
realize this and reload the script if further imports are executed or 
re-executed; otherwise additional imports will not cause the script to be 
reloaded for efficiency. As the script is loaded in its own environment 
(maintained by `import`) dependencies are kept (except those exposed through
attachment), as the following small example shows.

**Contents of "some_module.R":**
```R
## Possible
library(ggplot2)

## But would be better:
#import::here(qplot, .from = ggplot2)

## Note this operator overload is not something you want to `source`!
`+` <- function(e1, e2)
  paste(e1, e2)

## Some function relying on the above overload:
a <- function(s1, s2)
  s1 + rep(s2, 3)

## Another value.
b <- head(iris, 10)

## A value created using a function exposed by attachment 
p <- qplot(Sepal.Length, Sepal.Width, data = iris, color = Species)

## A function relying on a function exposed through attachment:
plot_it <- function()
  qplot(Sepal.Length, Sepal.Width, data = iris, color = Species)

```

**Usage:**
```R
import::from(some_module.R, a, b, p, plot_it)

## Works:
a("cool", "import")

## The `+` is not affecting anything here, so this won't work:
# "cool" + "import"

# Works:
b
p

## Does not work, as ggplot2 is no longer attached
## (would work with the import statement!):
#plot_it()
```

# Notes:

* When the arguments are unquoted they will be treated as they are written!
* If used in a package `import` will use the package's own namespace.

# See also:

For an interesting but slightly different idea of Python-like modules for R, see the 
[modules package](https://github.com/klmr/modules)
package by @klmr.
