## General
This is an update with the following features:

* One can now import objects defined in .R files (script/modules).
  When imports are made from a file, this file is sourced into
  an environment managed by `import`, and only the imported object(s)
  will be exposed. This allows for flexible scoping without the need
  to write a full package.

## Test environments
* local Windows installation (R 3.1.2)
* local Mac OS X (R 3.1.2)
* win-builder (devel R 3.2.0RC and release R 3.1.3)

## R CMD check results
There were no ERRORs or WARNINGs.

There was one NOTE:
  Components with restrictions and base license permitting such:
  MIT + file LICENSE
  File 'LICENSE':
    YEAR: 2015
    COPYRIGHT HOLDER: Stefan Milton Bache

## Downstream dependencies
There are no downstream dependencies.

## Other Notes (unchanged since last):
The package's functionality may alter the search path, but this
is intended and should be clear for the user, as the main functionality 
is an alternative to using `library`. For example the call 

`import::from(parallel, makeCluster, parLapply)`

will make an "imports" entry in the search path and place the
imported there.


