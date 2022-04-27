Version 1.2.1
=============

* Minor patch to import fixes a bug when importing from a library not defined in
the `libPaths`. The namespace was fixed to be imported earlier in the function
definition so that later functions that do not use a `lib.loc` parameter (such
as `getNamespaceExports`) can successfully reference the namespace.
* Minor patch to import fixes a bug where function `get` from namespaces other
than `package:base` can be incorrectly substituted in `make_import_call`. This
fix also applies to `getExportedValue`, even though this function is less likely
to be masked.

* import::from/here/into now support importing hidden objects (those with 
names prefixed by a period). Take care to avoid name clashes with argument names.

* import::from/into now support importing `.into` `symbol`s, regardless of `.character_only` value.

Version 1.2.0
=============

* import is now more strict and won't allow an import from a different
  environment to replace an existing import of that name and location.
* One can now import directly into an environment (which may not be attached)
  by wrapping it in braces, e.g. import::from(pkg, symbol, .into = {environment()})
* import::from/here/into now include a new option, `.character_only`, that
  suppresses non-standard evaluation and thus allows passing object names
  or locations in variables (character strings).
* import::from/here/into now include new options, `.all` and `.except`, that 
  allow the user to import all functions, or all functions except a few, from a
  package or module.
* import::from/here/into now include a new option, "`.chdir`", specifying whether 
  the working directory is changed before sourcing modules to import.
* import::from/here/into now include a new option, "`.directory`",  
* import::here() has been fixed to use environment() explicitly to import into
  the current environment, rather than importing into "" (the empty string),
  which no longer works because of upstream changes. Passing "" to "`.into`"
  parameter is now only a shorthand for .into = {environment()}.
* Using import::from(), import::into(), or library() inside a module that is 
  being sourced from the import::from/here/into
* The parameter order for import::here() has been changed to be consistent
  with import::from(). The change is backwards compatible because the moved 
  parameter (`.from`) was previously behind the ellipsis, requiring the use of 
  named parameters.
* Unit tests have been added and various issues fixed.
  

Version 1.1.0
=============
* There is now support to import objects from script files, i.e. a kind of
  "module". Scripts meant to expose objects for import should ideally be
  side-effect free, but this is not enforced. Any attachments are detached
  after import, but loaded namespaces remain loaded.

Version 1.0.2
=============

* You can now specify which library to use, and only one library is ever
  used in a single call: there is no ambiguity about where imports come from.
* There is a distinction between using double- and triple colon syntax;
  analogously to using :: and ::: operators.
* If the package is attached (e.g. via library) there is a startup message
  informing the user that the package is not meant to be attached.
* It is only possible to use the functions with the `import::` / `import:::`
  syntax.
