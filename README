# `import` - An Import Mechanism For R

# Motivation
The "default" way to use functionality from a package in R is to load the
entire package with `library` (or `require`). This can have the undesirable
effect of masking objects in the user's search path and can also make it
difficult to identify what functionality comes from which package when using
several `library` statements.

An alternative is to import a single object from a package, say `object <-
package::object`. The downside of this approach is that the object is placed in
the user's global work space, rather than being encapsulated somewhere else
in the search path (when using `library` to load `pkg` a namespace `package:pkg` 
will be attached in the search path which will contain the exported functions 
from `pkg`). Another minor point is that one can only import one object at a 
time using this approach.

The `import` package provides a simple alternative to importing and is inspired
in part by Python's `from some_module import some_function` syntax, and will
solve the two issues raised above.

# Installation and usage 

To install `import` from GitHub you can use `devtools`:

```R
devtools::install_github("smbache/import")
```

The `import` package is named to make usage expressive without having to load
the package using `library`. A basic example, which imports a few functions
from the `dplyr` package is:

```R
import::from(dplyr, select, arrange, keep_when = filter)
```

This does pretty much what it says: three functions are imported from `dplyr`,
two of which will keep their original name, and one which is renamed, say to
avoid name clash with `stats::filter`. The imported objects are placed in a
separate entity in the search path (@lionel suggests naming them 
"pied-à-terres", meaning living units some distance away from primary residence), 
which by default is named "imports". It is therefore also easy to get rid of 
them again with `detach("imports")`. One can specify which name to use, and 
use several to group imports:

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

In the examples above most arguments are provided unquoted. A more unambiguous
alternative is to quote the imputs, e.g. 

```R
import::from("ggplot2", "qplot")
```

# Notes:

* When the arguments are unquoted they will be treated as they are written!
* If used in a package `import` will use the package's own namespace.
