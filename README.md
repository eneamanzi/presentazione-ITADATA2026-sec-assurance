# Presentation template (Beamer, tema `Nicola`)

Presentazione Beamer con il tema `Nicola` (5 file `beamer*themeNicola.sty`, licenza MIT, © Nicola Bena), con build in CI.

La struttura, le macro e le tecniche di animazione vengono dalla presentazione di Nicola Bena "Beyond Layers" (SecAssure 2026). I testi sono segnaposto `CHANGE:`; nei commenti `GUIDA` di ogni frame c'è il consiglio su cosa va in quella slide.

## Struttura

- `main.tex`: preambolo, metadati (titolo, autori, istituti, evento), frame del titolo, `\input` delle sezioni
- `00_macro_common.tex`, `00_tikz_common.tex`: macro e stili TikZ riutilizzabili
- `00_macro_project.tex`: spazio per la notazione della nuova presentazione
- `examples/legacy-nicola/00_macro_legacy.tex`, `00_tikz_legacy.tex`: dipendenze delle slide originali di Nicola, caricate solo da `05_examples.tex`
- `01_intro.tex` (Background, Motivations), `02_core.tex` (Overview, Details, diagramma a stati), `03_exp.tex` (Experiments, Results), `04_conclusions.tex` (Conclusions, ringraziamenti)
- `assets/tex/`: le figure, un file per figura, animate con i numeri di overlay definiti nel frame; `assets/tex/03_plot_quality/`: il grafico e il suo `data.csv`
- `assets/img/`: le immagini che compaiono nelle slide
- `SPEECH.md`: la scaletta del discorso, una sezione per slide, da riempire
- `05_examples.tex` e `examples/`: la sezione di esempi in appendice (vedi sotto)

## Dove sta ogni tecnica

| Tecnica | Dove |
|---|---|
| Elenco + figura, un elemento evidenziato alla volta | Background (`01_intro.tex`, `assets/tex/01_fig_cert_process.tex`) |
| Dialogo con personaggi e bolle, bolle ancorate ai nodi, immagine che compare | Motivations (`01_intro.tex`, `assets/tex/02_fig_cert_process.tex`) |
| Blocco di definizione con tupla | Details (`02_core.tex`) |
| Diagramma di stati | `02_core.tex`, `assets/tex/02_fig_cert_status.tex` |
| `\pause`, testo e immagine in colonne | Experiments (1) (`03_exp.tex`) |
| Intestazione fissa e contenuto che cambia (`overlayarea`, `\only`), tabella con `multirow` | Experiments (2) (`03_exp.tex`) |
| Grafico a barre con `groupplot`, dati da CSV, legenda condivisa | Results (`assets/tex/03_plot_quality/plot_01.tex`) |
| Blocco colorato come la barra del titolo | ringraziamenti (`04_conclusions.tex`) |

## Esempi (appendice)

Dopo i ringraziamenti c'è una sezione "Examples", numerata a parte (non conta nel "x / N" della talk): pezzi di codice pronti da copiare, uno per tecnica, presi dalle presentazioni di Nicola (SecAssure 2026 e ICWS 2024) e resi generici. Ogni file in `examples/` ha in cima un commento che spiega la tecnica e cosa copiare.

| Esempio | Tecnica |
|---|---|
| `02_highlighted_list_next_to_figure.tex` | elenco con un elemento evidenziato accanto a una figura sincronizzata |
| `03_technical_definition.tex` | definizione tecnica formattata con una tupla |
| `04_progressive_content_with_pause.tex` | contenuto progressivo con `\pause` |
| `05_replacing_content_with_only.tex` | contenuto alternativo con `\only` e `overlayarea` |
| `06_tables.tex` | tabelle impilate con intestazioni colorate, `\multirow` e `\multicolumn` |
| `07_plots_external_data.tex` + `lines_01.dat`, `lines_02.dat`, `data_comparison.csv` | frase progressiva, grafici e dati esterni |
| `08_synchronized_characters_and_speech.tex` + `fig_overlay_graph.tex` | personaggi e fumetti sincronizzati con una figura riusata |
| `09_chevrons.tex` + `fig_chevrons.tex` | riga di chevron con descrizioni e dissolvenza dello sfondo |
| `10_reusable_pic_component.tex` + `fig_pic.tex` | componente riusabile con `\pic` e argomenti |
| `11_callouts_and_speech_bubbles.tex` + `fig_callouts.tex` | callout, linguette e fumetti |
| `12_title_logos_and_funding.tex` | slide del titolo con più autori, loghi e finanziamenti |

Per toglierla basta cancellare in `main.tex` le due righe `\appendix` e `\input{05_examples.tex}`.

Due scelte da conoscere:

- La libreria TikZ `chains` (usata da Nicola per i chevron) **non è caricata**: con quella le figure a bolle delle Motivations stampano centinaia di caratteri senza font. I chevron sono quindi posizionati con `right=3pt of ...`.
- Il codice colorato con `minted` (come nel deck ICWS) non è abilitato: serve Pygments installato sul PC e nella CI. Come attivarlo è scritto nel commento di `11_callouts_and_speech_bubbles.tex`.

## Nuova presentazione

Tutto ciò che va cambiato è marcato con `CHANGE:` (Ctrl+F su tutto il progetto).

- [ ] "Use this template" su GitHub, poi clone.
- [ ] `main.tex`: titolo, autori, email e sito del relatore, istituti, evento. Gli stessi nomi compaiono in `\documentclass` (metadati del PDF) e in `\author`; i numeri `\inst{N}` devono coincidere con `\institute`.
- [ ] `01_intro.tex`, `02_core.tex`, `03_exp.tex`, `04_conclusions.tex`: i testi. Ogni frame ha un commento `GUIDA`. Per un componente in più si copia il frame Details.
- [ ] Figure: le scritte dentro `assets/tex/*.tex` (caselle, frecce, dialoghi, etichette del grafico) e i dati di `data.csv` sono ancora quelli del deck originale, e vanno sostituiti. Anche le immagini in `assets/img/`.
- [ ] `SPEECH.md`: il testo da dire, una sezione per slide.
- [ ] Prima build in CI (push o "Run workflow"): deve essere verde prima di scrivere contenuto.

## Compilare

Serve **TeX Live 2026** (LuaLaTeX). In VSCode: salva un `.tex` oppure Ctrl+Alt+B. Da terminale:

```
latexmk main.tex
```

La compilazione completa richiede circa un minuto e mezzo: `latexmk` fa tre passate, e ogni passata ricompone tutte le animazioni. Per vedere solo il risultato di una modifica basta una passata con `lualatex main.tex`.

`.latexmkrc` imposta LuaLaTeX (con `-shell-escape`), i file ausiliari in `.temp/` e il PDF accanto ai sorgenti (non versionato). Il valore `.temp` compare due volte, in `.latexmkrc` e in `.vscode/settings.json` (`latex-workshop.latex.auxDir`): se lo cambi, cambia entrambi.

In `.vscode/settings.json` la compilazione automatica è solo al salvataggio (`onSave`): con il default ogni build cambia `.temp/main.bbl` e ne fa partire un'altra. Tieni una sola finestra di VSCode sulla cartella.

Al salvataggio `latexindent` riformatta il file: la prima volta cambia molte righe.

## CI

`.github/workflows/build-latex.yml` compila a ogni push su `main` o `master` che non tocca solo file `.md`, e pubblica sul branch `pdf-release`:

- `https://raw.githubusercontent.com/<utente>/<repo>/pdf-release/presentation.pdf`

La versione di TeX Live è fissata nel workflow (`texlive_version`).
