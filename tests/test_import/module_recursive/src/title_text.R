# If import::from does not change the path to the dirname(path)
# (like the chdir=TRUE in sys.source), this shouldn't work.
import::from("to_title.r", to_title)

print_title_text = function(text){
  print(to_title(text))
}
