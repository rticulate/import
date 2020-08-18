# If import::from does not change the path to the dirname(path)
# (like the chdir=TRUE in sys.source), this shouldn't work.
import::here(.from=to_title.R, to_title)

print_title_text = function(text){
  print(to_title(text))
}
