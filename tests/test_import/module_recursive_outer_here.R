# Import utility function using import::here() is the recommended usage
import::here(module_recursive_inner.R, to_title)

print_title_text = function(text){
  print(to_title(text))
}
