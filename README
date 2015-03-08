# `import` - An Import Mechanism For R

# Motivation
The typical way of using functionality exposed by a package in R is to load 
(and attach) the entire package with `library` (or `require`). This can have 
the **undesirable effect of masking objects** in the user's search path and can 
also make it difficult and **confusing to identify** what functionality comes 
from which package when using several `library` statements.

An alternative is to import a single object from a package, say `object <-
package::object`. The downside of this approach is that the object is **placed 
in the user's global work space**, rather than being encapsulated somewhere else
in the search path (when using `library` to load `pkg`, a namespace `package:pkg` 
will be attached in the search path which will contain the exported functions 
from `pkg`). Another minor point is that one can **only import one object at a 
time** using this approach.

The `import` package provides a simple alternative to importing and is inspired
in part by Python's `from some_module import some_function` syntax, and will
solve the two issues raised above.


# Installation and usage 

To install `import` from GitHub you can use `devtools`:

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
separate entity in the search path (@lionel suggests naming them "pied-à-terres", 
meaning living units some distance away from primary residence), which by 
default is named "imports". It is therefore also easy to get rid of them again 
with `detach("imports")`. The main point is that it is **clear which functions 
will be used and where they come from**. It's noteworthy that there is nothing 
special going on: the `import::from` function is only a convinient wrapper 
around `get` (as is `:::`) and `assign`. 

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
alternative is to quote the imputs, e.g. 

```R
import::from("ggplot2", "qplot")
```

# Notes:

* When the arguments are unquoted they will be treated as they are written!
* If used in a package `import` will use the package's own namespace.

# See also:

For an interesting but slightly different idea of Python-like modules for R, see the 
[modules package](https://github.com/klmr/modules)
package by @klmr.
