# Using Lean code in LaTeX with minted and latexmk

These instructions assume you are using a Unix-like operating system. 

This repository contains a minimal LaTeX example file `sample.tex` and a corresponding `.latexmkrc`
file.

## Pygments

You will need to install the Python package `pygments`. There are several installation options:

* Using `pip`. If you're using the `pip` package manager, you can just type `pip install Pygments`
  at the command prompt.
* Naturally, you can also install the `pygments` package in a `venv` virtual environment. I won't
  explain how to do that here.
* If you're running macOS with the homebrew package manager, type `brew install pygments`.

## Fonts

Lean uses several glyphs that are not available in the standard LaTeX font families. You'll need a
suitable alternative, such as [GNU FreeFont](https://www.gnu.org/software/freefont/). You can
install this either manually, via the previous link, or by the package manager for your system. For
example, `brew font-freefont` for macOS with homebrew.


## Minted

The minted LaTeX package is required. To use it, add the following to your LaTeX preamble:

    \usepackage{fontspec}   
    \setmonofont{FreeMono}
    
    \usepackage[outputdir=.build]{minted}
    \newmintinline[lean]{lean4}{bgcolor=white}
    \newminted[leancode]{lean4}{fontsize=\footnotesize}
    \usemintedstyle{tango}  % a colourful theme

The top two lines are needed for providing Unicode glyphs missing from the standard fonts. The
second line chooses the FreeMono typeface from the GNU Free Font package.

We use the minted package. I prefer not to put my auxiliary files in the same directory as the
source files. Here, I use the option `outputdir=.build` to put the minted auxiliary files in the
`.build` subdirectory of the current directory.

We define an inline minted command and a minted environment for Lean 4.

## Latexmkrc and XeLaTeX

Latexmk is the nice modern way to build LaTeX documents. This tool can be configured on a
per-directory basis by adding a `.latexmkrc` file in the relevant directory.

For example, to ensure that all the auxiliary files are saved in a hidden directory called `.build`,
just add the following

    $aux_dir = '.build';

I use the following command to specify how PDFs should be built.

    $pdflatex = 'xelatex -synctex=1 -interaction=nonstopmode '
      . '--shell-escape -file-line-error -verbose '
      . '-output-directory=. '
      . '-aux-directory=' . $aux_dir . ' %O %S';

You can call latexmk using `latexmk -pdf myfile.tex` where `myfile.tex` is the name of your TeX
file.

## Using minted

With the above definitions, Lean code can be inserted into your LaTeX file as follows:

    Here is some inline lean \lean{0 ≤ b^2}. And a longer piece of Lean:

    \begin{leancode}
    example (h : x = (-b + √(b^2 - 4*c))/ 2)
      (k : 0 ≤ b^2 - 4 * c):  x^2 + b * x + c = 0 := by
        sorry
    \end{leancode}

## Syntax highlighting in neovim with VimTeX

If you're using neovim, then syntax highlighting is provided by the file `lean.vim` found in the
[lean.nvim](https://github.com/Julian/lean.nvim) plugin. 

The VimTeX plugin uses the name of the minted language to determine the correct vim syntax file to
use. Unfortunately, the minted language `lean4` is not the same as the name (`lean`) of the syntax
file. My hack to get around this is to create a symlink. First, you need to locate the `lean.vim`
file on your system. From within neovim, you can do this via:

    :echo findfile('syntax/lean.vim', &runtimepath)

At the terminal, change to the directory containing the `lean.vim` file and make a symlink via:

    ln -s lean.vim lean4.vim
