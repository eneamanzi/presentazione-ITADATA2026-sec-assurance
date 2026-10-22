# Motore: LuaLaTeX (VSCode, terminale, CI, Overleaf). Qui sta tutta la configurazione di compilazione.
$pdf_mode = 4;
$lualatex = 'lualatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Cartella dove vanno i file ausiliari (.aux, .log, ecc.).
# Deve coincidere con "latex-workshop.latex.auxDir" in .vscode/settings.json.
$aux_dir = '.temp';

# Dove va il PDF finale ('.' = accanto ai sorgenti).
$pdf_dir = '.';
