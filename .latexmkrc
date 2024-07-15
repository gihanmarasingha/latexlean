# Set the auxiliary directory
$aux_dir = '.build';

# Custom xelatex command with additional options
$pdflatex = 'xelatex -synctex=1 -interaction=nonstopmode '
  . '--shell-escape -file-line-error -verbose '
  . '-output-directory=. '
  . '-aux-directory=' . $aux_dir . ' %O %S';
