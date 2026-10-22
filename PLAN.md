# Piano di razionalizzazione del template

Questo file raccoglie solo osservazioni e decisioni concordate per rendere il
template più riutilizzabile senza eliminare il lavoro originale di Nicola.

## Obiettivo

Mantenere il tema grafico di Nicola e trasformare il resto in una struttura
più comprensibile e riutilizzabile:

```text
tema di Nicola
+ strumenti comuni
+ contenuto specifico del progetto
+ materiale legacy di Nicola
```

La presentazione deve rimanere semplice da usare e i file principali devono
restare nella root. Non si introduce ora una struttura complessa di cartelle.

## Decisioni confermate

- I cinque file `.sty` del tema restano nella root e non vengono modificati:
  - `beamerthemeNicola.sty`
  - `beamercolorthemeNicola.sty`
  - `beamerfontthemeNicola.sty`
  - `beamerinnerthemeNicola.sty`
  - `beamerouterthemeNicola.sty`
- Non si cancellano macro, stili, figure o esempi esistenti.
- `00_macro.tex` e `00_common_tikz.tex` saranno classificati e,
  successivamente, eventualmente separati.
- La distinzione da mantenere è:
  - **common**: strumenti riutilizzabili;
  - **project**: macro e stili del progetto Big Data API;
  - **legacy**: materiale legato alla ricerca e alle figure di Nicola.
- Per i nuovi contenuti si preferiscono macro con nomi leggibili per gli
  overlay.
- Non si vuole mantenere una pluralità di convenzioni equivalenti come stile
  d'uso del template.

## Macro: cosa è comune e cosa varia

Le macro comuni possono essere caricate sempre. Non devono però contenere i
nomi degli step di una slide specifica.

### Macro common

Contengono solo definizioni utili in più progetti, per esempio:

- abbreviazioni o simboli veramente generali;
- piccole convenzioni di formattazione;
- eventuali helper generici per figure e overlay.

Una macro è common se il suo significato non dipende dal paper o dal tema
scientifico della presentazione.

### Macro project

Contengono la terminologia e la notazione di questa presentazione, per
esempio concetti come:

- API contract;
- probe;
- security oracle;
- assessment engine;
- assurance taxonomy.

Gli step della narrazione appartengono invece alla singola slide o figura,
non a un file common globale:

```tex
\newcommand{\stepProblem}{2}
\newcommand{\stepSolution}{3}
```

Queste macro possono essere definite nel file della slide oppure in un file
project dedicato se sono riusate da più slide.

### Macro legacy

Sono macro mantenute per compatibilità con il materiale originale di Nicola,
ma non necessarie come base generale del template. Tra quelle osservate:

- certificazione e certification model;
- certificate, evidence e hypergraph;
- notazione specifica della vecchia ricerca;
- nomi di modelli LLM;
- poisoning e random forest;
- terminologia relativa agli esperimenti originali.

Non vengono rimosse finché non è stata verificata ogni dipendenza.

## Stili TikZ: cosa è comune e cosa è specifico

In `00_common_tikz.tex` sono mescolati stili di natura diversa.

### Candidati common

- stili base per nodi e collegamenti;
- `entity`, `artifact`, `service`;
- `link`, `on link`;
- forme e colori generici;
- helper per visibilità e highlighting negli overlay:
  - `visible on`;
  - `on slide`;
  - `highlight light`;
  - `highlight text`;
  - `highlight link`.

Questi descrivono come disegnare o animare un elemento, non il significato
scientifico dell'elemento.

### Candidati legacy o project-specific

- poisoning;
- dataset e random forest;
- stili per hypergraph;
- certificazione e certification process;
- callout e personaggi della narrazione originale, se non servono come
  tecnica generale;
- colori e stili associati esclusivamente agli esperimenti di Nicola.

La classificazione definitiva richiede una verifica delle dipendenze delle
figure prima di spostare qualsiasi definizione.

## Convenzione overlay da adottare

Per i nuovi contenuti si adotta una convenzione principale:

1. ogni passaggio importante ha un nome leggibile;
2. il nome dello step viene riutilizzato nel testo e nella figura;
3. gli step sono definiti vicino alla slide o al componente che li usa;
4. le catene di calcolo automatico con `\pgfmathsetmacro` non sono il
   default.

Esempio:

```tex
\newcommand{\stepProblem}{2}
\newcommand{\stepSolution}{3}
```

Nel testo:

```tex
\item<\stepProblem->{The problem}
```

In una figura TikZ:

```tex
\node[visible on=<\stepProblem->] {API};
```

Per evidenziare:

```tex
\node[on slide={<\stepProblem> highlight light}] {API};
```

`visible on` e `on slide` non sono convenzioni narrative concorrenti: sono
strumenti tecnici per applicare la stessa timeline agli elementi TikZ.

## Overlay: valutazione delle alternative

### `\pause`

È semplice e adatto a testo lineare, ma nasconde la numerazione e rende meno
prevedibile la sincronizzazione con una figura. Non sarà la convenzione
principale per figure animate.

### Overlay espliciti

Sintassi come `\only<2>`, `\item<2->` e `\alert<3>` è standard Beamer e offre
controllo preciso. È la base su cui si appoggiano gli helper TikZ.

### Macro con nomi leggibili

Sono la convenzione consigliata per collegare testo e figure senza spargere
numeri anonimi nel codice.

### `\pgfmathsetmacro`

È utile per timeline lunghe e dipendenze numeriche, ma l'uso attuale in
`01_intro.tex` è molto verboso e fortemente accoppiato alla narrazione
originale. Non sarà il default del template.

## Stato della repo osservato

- `main.tex` orchestra tema, macro, stili, sezioni e appendice.
- `01_intro.tex` contiene due frame:
  - Background;
  - Motivations.
- Le figure TikZ sono incluse da `assets/tex/`.
- `01_fig_cert_process.tex` e `02_fig_cert_process.tex` dipendono da
  variabili di overlay definite nel frame che le include.
- Gli esempi in `examples/` mostrano sia tecniche standard Beamer sia helper
  TikZ del template.
- Molti testi delle sezioni principali sono ancora marcati `CHANGE:`.
- Le immagini e i dati attuali sono ancora in parte quelli dimostrativi del
  materiale originale.

## Prossimi passi, non ancora eseguiti

1. Inventariare tutte le definizioni in `00_macro.tex`.
2. Inventariare tutti gli stili in `00_common_tikz.tex`.
3. Tracciare le dipendenze tra macro, stili e figure.
4. Classificare ogni elemento come common, project o legacy.
5. Decidere i nomi dei file separati senza rompere la compilazione.
6. Aggiornare gli `\input` in `main.tex`.
7. Solo dopo, semplificare gradualmente gli overlay di `01_intro.tex`.

Finché l'inventario e il tracciamento delle dipendenze non sono completati,
non si spostano né si cancellano definizioni.

## Inventario preliminare completato

L'inventario seguente è stato ricavato dai file attuali e dalle loro
occorrenze nella repo. È una classificazione operativa preliminare: prima di
spostare definizioni bisogna mantenere invariati gli `\input` oppure aggiornare
tutti i riferimenti in modo coordinato.

### `00_macro.tex`

#### Candidati common

Sono macro di notazione o formattazione che non dipendono necessariamente da
un dominio:

- `\referred` e `\setStyle`;
- `\angled`;
- `\steponly`, `\step`, `\steps`, `\Step`, `\Steps`;
- `\stepExperimentOnly`, `\StepExperiment`;
- `\detail`, `\detailLow`, `\detailMediumLow`, `\detailMediumHigh`,
  `\detailHigh`;
- `\ok`, `\notOk`;
- `\bigO`;
- `\spaceOne`;
- helper per testo e citazioni come `\parMini`, `\fullCiteMini`,
  `\parAlmostMini`, `\fullCiteAlmostMini`, se richiesti dal template;
- helper matematici generici come `\sourceFunction`, `\firstFunction`,
  `\lastFunction` e `\arcCounterOf`, dopo verifica dell'uso effettivo.

La macro `\referred` è genericamente riutilizzabile, anche se oggi viene
usata soprattutto nella notazione di certificazione.

#### Candidati project o legacy di certificazione

Queste definizioni descrivono il modello scientifico originale e non il tema
grafico:

- `\prop`, `\propertyNameStyle`, `\target`, `\targetSet`,
  `\mechanism`, `\evidCollectionModel`, `\evalFn`;
- `\certModel`, `\certModelSet`, `\cert`, `\certSet`, `\evid`, `\attr`;
- `\repo`, `\signature`, `\signatureCA`, `\signatureAL`;
- `\dimension`, `\verificationStep`, `\targetInput`;
- `\hypergraphEvalRule`, `\hypergraphAll`, `\hypergraphInstance`,
  `\verificationPath`, `\hypergraphCertModel`, `\hypergraphCert`,
  `\hyperpath`;
- simboli e funzioni per nodi, archi, percorsi e grafi di verifica;
- `\guardFunction`, `\evidenceFunction`, `\nil`, `\error`;
- `\propertyLabel`, `\behaviorSet`, `\verificationStepTarget`,
  `\verificationStepActivity`, `\conditionGuardFunction`;
- `\verificationGraphAnnotated`, `\verificationNodesAnnotated`,
  `\verificationArcsAnnotated`;
- `\applTypeText...`;
- `\service`, abbreviazioni di servizi e meccanismi;
- `\CA`, `\AL` e le loro varianti applicative/CSP/ISP;
- `\certStatusStyle`, `\certStatusValid`, `\certStatusSuspended`,
  `\certStatusRevoked`.

Queste macro possono diventare project-specifiche per una presentazione
nuova, oppure rimanere in una sezione/file `legacy` per preservare le figure
di Nicola. Non sono candidati al common solo perché sono scritti in forma
astratta.

#### Candidati legacy per esperimenti o LLM

- abbreviazioni di pre-training, adaptation, inference e artifact;
- viste e dimensioni associate a tali fasi;
- `\succSymbol`, `\succFn`, `\foundation`;
- `\gapStyle`, `\gap`;
- `\testCaseOutput`, `\testCaseResult`;
- `\FPathStar...`, `\BPathStar...`, `\BFPathStar...`,
  `\PathStar...`;
- `\evalNode`, `\evalNodeAll`;
- `\nodes`, `\arcs`, `\nodesFailed`;
- `\modelName` e tutti i wrapper `\llm...`;
- `\E`, `\Efirst`, `\Elast`, `\Erandom`, `\Enull`;
- `\llm`, `\probe`, `\myN`, `\myM`, `\accordance`, `\prompt`, `\answer`,
  `\orderBias`;
- `\FKGL...`, `\DL...`;
- `\challenge`;
- `\timestyle`, `\timeshort`, `\timemedium`, `\timelong`;
- `\pavail`, `\ppriv`, `\pConfTransit`, `\pConfStorage`;
- `\approachSOTA`, `\approachOur`, `\certTimeSymbol`,
  `\certTimeFunction`.

Questa sezione include materiale non usato dalle slide attuali oppure usato
solo dal grafico e dalla ricerca originale. Va conservata finché non è stata
verificata la necessità di compatibilità.

### `00_common_tikz.tex` (sorgente attuale; futuro `00_tikz_common.tex`)

#### Candidati common

Sono strumenti di disegno o animazione riutilizzabili:

- colori e stili generici di evidenziazione:
  `HighlightColor`, `HighlightFill`, `HighlightFillLight`,
  `HighlightProfile`;
- `invisible`, `visible on`, `alt`, `on slide`;
- `link`, `low link`, `on link`;
- stili base per nodi: `entity`, `artifact`, `service`, `rboxes`, `boxes`,
  `object`, `container`;
- stili generici di evidenziazione:
  `highlight base`, `highlight`, `highlight light`,
  `highlight very light`, `highlight double`, `highlight text`,
  `highlight link`;
- `connector`, `connector assurance`;
- `basic question`, `basic question no color`, `box label`,
  `a bit of transparency`, `a bit of transparency label`;
- `speaking question` e `certificate callout`, se mantenuti come esempi
  generici di callout;
- `includegraphicswithwisibility`, correggendo eventualmente il nome solo
  in una futura modifica esplicita;
- `rboxes`, già riutilizzato dagli esempi;
- `basic graph node`, `hyperarc` e i `pic` per hyperarc, se si decide che
  i grafi sono una tecnica comune del template.

Gli helper di overlay sono candidati common perché implementano il “come”:
applicano una condizione Beamer a uno stile TikZ. Non contengono la
narrazione o il significato degli step.

#### Candidati legacy di poisoning/ML

- `PoisonedRedForText`, `PoisonedRedOut`, `UnPoisonedGreen`,
  `UnPoisonedGreenForText`;
- `\poisonedRF`;
- `\forhash`, `\forrisk`, `\forToolTraining`, `\forToolTesting`;
- `\headerEnsemble...`, `\headerRf...`;
- `\codePoisoned`, `\codeNonPoisoned`;
- `\devilLarge`, `\devilSmall`;
- `dataset`, `rf`, `partition`, `poisoning link`, `poisoned`,
  `majority voting`;
- stili per barre, accuracy, poisoning attack, super container e linee
  sperimentali;
- colori `Completed` e `InProgress`, se usati solo dal vecchio workflow.

#### Candidati legacy di certificazione/grafi

- `service in certification process`;
- `ca cert`;
- `step separator`;
- `probe link`;
- `label desc`, `label desc with shape`;
- `arrow`, `desc`, `activity`;
- `verification step`, `evaluation function`,
  `evaluation function global`;
- `visited node`, `visited arc`, `pruned node`, `pruned arc`;
- `evidence content`;
- `orange in violet out double`, `orange out`;
- `highlighted hyperarc in path`, `hyperarc in verification path`,
  `node in verification path`;
- `certificate callout`, se resta legato alla certificazione.

Questi stili non sono necessariamente inutili in assoluto, ma il loro
significato attuale è legato alle figure e alla terminologia di Nicola.

## Tracciamento delle dipendenze

### Catena di caricamento

`main.tex` carica in ordine:

1. pacchetti LaTeX e librerie TikZ;
2. il tema `Nicola`;
3. `00_macro.tex`;
4. `00_common_tikz.tex`;
5. i file delle sezioni;
6. gli esempi dell'appendice.

Di conseguenza:

- `00_macro.tex` può usare pacchetti caricati nel preambolo, tra cui
  `xifthen`, `pifont`, `amsmath` e gli strumenti matematici;
- `00_common_tikz.tex` dipende dai colori definiti dal tema e dalle librerie
  TikZ caricate in `main.tex`;
- le figure incluse dopo questi file possono usare entrambe le famiglie di
  definizioni.

### Figure principali

- `assets/tex/01_fig_cert_process.tex`
  - usa gli stili `entity`, `artifact`, `service`, `link`, `on link`;
  - usa `on slide` e gli stili `highlight light`, `highlight link`,
    `highlight text`;
  - dipende dalle macro di overlay definite nel frame Background:
    `\numberProperty`, `\numberTarget`,
    `\numberEvidenceCollectionModel`, `\numberCertificationModel`,
    `\numberExecution`, `\numberCertificate`.
- `assets/tex/02_fig_cert_process.tex`
  - usa gli stili `service`, `service in certification process`, `link`,
    `on link`, `speaking question`;
  - usa `visible on`, `callout absolute pointer`, personaggi TikZ e
    `varwidth`/`widthof`;
  - usa macro di overlay definite nel frame Motivations;
  - usa macro di dominio come `\target`, `\certModel`, `\cert` e
    `\referred`;
  - include `assets/img/patrick_happy.jpg`.
- `assets/tex/02_fig_cert_status.tex`
  - usa `rboxes`;
  - usa `\certStatusValid`, `\certStatusSuspended`,
    `\certStatusRevoked`, `\cert` e `\referred`.
- `assets/tex/03_plot_quality/plot_01.tex`
  - usa `\certTimeSymbol` e `\approachSOTA`;
  - dipende da PGFPlots, dal CSV e dai nomi delle serie del vecchio
    esperimento.

### Esempi

- `examples/fig_reuse.tex` usa `rboxes`, `on slide`, `highlight light`,
  `link` e macro di overlay definite dal frame chiamante.
- `examples/fig_pic.tex` usa `rboxes`, `on slide`, `highlight light` e la
  tecnica TikZ `pic`.
- `examples/fig_callouts.tex` usa `rboxes`, `visible on`, `on slide`,
  `box label`, `basic question no color`, `speaking question` e callout
  TikZ.
- `examples/fig_chevrons.tex` usa `on slide`, `visible on` e macro di
  overlay definite dall'esempio.

Questo conferma che gli helper di overlay, `rboxes`, `link` e alcuni callout
sono riutilizzabili oltre alle figure di certificazione. Le macro di
dominio, invece, non sono necessarie per gli esempi generici.

## Classificazione operativa

### Common da preservare come API del template

- tema `.sty`, invariato;
- helper overlay TikZ: `visible on`, `alt`, `on slide`;
- forme base e collegamenti: `entity`, `artifact`, `service`, `boxes`,
  `rboxes`, `link`, `on link`;
- evidenziazione: `highlight light`, `highlight text`, `highlight link`;
- callout riutilizzabili;
- piccole macro di notazione e formattazione realmente indipendenti dal
  progetto, dopo verifica dell'uso.

### Project da definire per questa presentazione

Al momento il progetto Big Data API non ha ancora macro proprie consolidate.
In futuro potranno entrarvi, per esempio, le definizioni condivise da più
slide per contract, probe, oracle, assurance domain e assessment engine.
Non vanno aggiunte ora solo per riempire il file.

### Legacy da isolare ma non cancellare

- notazione di certificazione;
- notazione di hypergraph e verification path;
- LLM e metriche del vecchio esperimento;
- poisoning/random forest;
- stili di certificazione, ML e grafi specifici;
- figure e immagini dimostrative attuali.

## Proposta di file, senza applicarla ancora

La struttura può restare nella root e usare pochi file espliciti:

```text
00_macro_common.tex
00_macro_project.tex
00_macro_legacy.tex
00_tikz_common.tex
00_tikz_legacy.tex
```

Possibile alternativa ancora più conservativa:

```text
00_macro_common.tex
00_macro_legacy.tex
00_tikz_common.tex
00_tikz_legacy.tex
```

In questa seconda alternativa gli stili TikZ project-specific della nuova
presentazione restano nella figura finché non
esistono abbastanza definizioni da giustificare un file separato.

La scelta non è ancora applicata. Prima bisogna decidere se `project` deve
essere un file esplicito già vuoto oppure se va creato solo quando compaiono
macro/stili condivisi da più slide.

## Esito degli step richiesti

- **Step 1 - inventario macro:** completato a livello preliminare.
- **Step 2 - inventario stili TikZ:** completato a livello preliminare.
- **Step 3 - dipendenze:** tracciate per i file principali, figure ed esempi.
- **Step 4 - classificazione:** proposta per common, project e legacy.
- **Step 5 - nomi dei file:** proposte due strutture conservative; nessuna
  modifica applicata.

Nessun file LaTeX, `.sty`, immagine o configurazione è stato modificato per
questa analisi. È stato aggiornato soltanto `PLAN.md`.

## Revisione di consistenza e decisione architetturale

Questa sezione aggiorna e prevale sulle classificazioni preliminari sopra
riportate dove sono più conservative.

### Correzioni emerse dal controllo

- Una macro non è common solo perché è astratta o matematicamente elegante:
  deve essere indipendente dal dominio e avere dipendenze disponibili nel
  template.
- `\referred`, `\setStyle`, `\target`, `\service`, `\node`, `\arc`,
  `\error`, `\CA` e `\AL` non vanno promosse automaticamente al common.
  Sono nomi brevi, legati alla notazione originale o potenzialmente
  conflittuali; restano legacy finché non viene verificata la compatibilità.
- `\fullciteMini` e `\fullciteAlmostMini` dipendono da `\fullcite`, ma
  `biblatex` è commentato in `main.tex`: non sono strumenti common
  autosufficienti.
- `\CA` e `\AL` usano `\gls`, mentre `glossaries` non è caricato nel
  preambolo attuale: restano macro legacy con dipendenza non garantita.
- `entity`, `artifact`, `service`, `link`, `container` e altri stili sono
  definiti in più blocchi TikZ con proprietà diverse. Prima di considerarli
  API common bisogna consolidare le definizioni duplicate.
- `speaking question`, hypergraph, hyperarc, certification process e gli
  stili poisoning/ML non sono common di base: possono diventare moduli
  opzionali, ma il loro significato attuale è specifico della ricerca di
  Nicola.
- `includegraphicswithwisibility` è riutilizzabile come idea, ma il refuso
  nel nome è parte dell'API attuale: non va rinominato durante una semplice
  separazione.

### Common effettivo da progettare

Il common iniziale deve essere volutamente piccolo:

- helper overlay TikZ: `visible on`, `alt`, `on slide`;
- primitive grafiche già dimostrate dagli esempi: `boxes`, `rboxes`, `link`,
  `on link`;
- highlighting: `highlight light`, `highlight text`, `highlight link`;
- eventuali callout solo se vengono mantenuti come tecnica generale;
- macro tipografiche o matematiche solo dopo verifica di dipendenze e uso.

`entity`, `artifact`, `service`, `connector`, `container`, `object`,
`basic graph node` e `hyperarc` sono candidati da consolidare o rendere
opzionali, non API common già approvate.

### Struttura raccomandata

Restando nella root e senza creare un file project vuoto, la struttura
raccomandata è:

```text
00_macro_common.tex
00_macro_legacy.tex
00_tikz_common.tex
00_tikz_legacy.tex
```

Regole:

- i cinque `.sty` di Nicola restano invariati;
- `00_macro_common.tex` contiene solo il common effettivo;
- `00_macro_legacy.tex` conserva tutte le macro attuali non ancora
  dimostrate comuni;
- `00_tikz_common.tex` contiene solo gli helper TikZ consolidati;
- `00_tikz_legacy.tex` conserva gli stili specifici e quelli ancora
  ambigui;
- le macro di dominio della nuova presentazione vengono aggiunte solo quando
  sono realmente riusate da più slide;
- solo allora si valuta la creazione di `00_macro_project.tex` o di un file
  TikZ project-specifico.

Questa soluzione evita sia un common enorme e fragile sia una proliferazione
prematura di file.

### Overlay: decisione confermata

La superficie d'uso per i nuovi contenuti è una sola:

```tex
\newcommand{\stepProblem}{2}
\newcommand{\stepSolution}{3}
```

Gli stessi nomi vengono usati nel testo e nelle figure. Gli helper
`visible on` e `on slide` restano dettagli tecnici comuni per applicare la
timeline alle figure TikZ. `\pause` è ammesso per testo lineare isolato, ma
non è la convenzione per sincronizzare figure. Le catene di
`\pgfmathsetmacro` restano compatibilità legacy e non il default.

### Stato aggiornato

- inventario macro: completato preliminarmente;
- inventario stili: completato preliminarmente;
- dipendenze: controllate sui file principali e sugli esempi;
- classificazione: rivista in modo conservativo;
- nomi dei file: definiti nella proposta raccomandata;
- codice: non modificato;
- separazione dei file: non ancora applicata.

Prima della futura separazione sarà necessaria una compilazione di controllo,
seguita da una separazione mantenendo inizialmente tutte le definizioni e da
una seconda compilazione. Solo dopo si potranno ridurre davvero i file common
senza rischiare regressioni.

## Decisioni ancora aperte prima dell'applicazione

1. **Perimetro esatto del common macro.** Confermare quali macro tipografiche
   e matematiche entrano in `00_macro_common.tex`; il criterio deve essere
   indipendenza dal dominio e dipendenze disponibili, non il solo riuso
   sintattico.
2. **Consolidamento degli stili duplicati.** Decidere se mantenere una sola
   definizione per `entity`, `artifact`, `service`, `link` e simili oppure
   conservare temporaneamente le definizioni legacy con nomi separati. Questa
   è la scelta con maggiore rischio di cambiamenti visuali.
3. **Perimetro del TikZ common.** Confermare che `00_tikz_common.tex`
   contenga soltanto overlay, primitive base, collegamenti e highlighting,
   mentre callout, grafi e figure di certificazione restino legacy o moduli
   opzionali.
4. **Gestione degli overlay legacy.** Decidere se le figure attuali
   continueranno a usare i nomi `\number...` durante la migrazione oppure se
   verranno convertite subito alla convenzione con nomi leggibili. La
   conversione immediata è più pulita, ma aumenta il rischio e lo scope.
5. **Politica di compatibilità.** Stabilire se il template deve compilare
   anche materiale legacy non usato dalle slide principali oppure soltanto il
   deck corrente e gli esempi mantenuti.
6. **Ordine di migrazione.** Dopo le decisioni sopra, scegliere se:
   - prima copiare tutto nei nuovi file e verificare la compilazione;
   - poi ridurre il common;
   - infine convertire gli overlay.
7. **Verifica finale.** Definire come confrontare il PDF prima/dopo:
   almeno compilazione senza errori e controllo visivo delle slide e degli
   esempi che devono restare funzionanti.

I nomi dei file sono invece confermati:

```text
00_macro_common.tex
00_macro_legacy.tex
00_tikz_common.tex
00_tikz_legacy.tex
```

## Chiarimenti sulle decisioni aperte

### Criterio del common

Il criterio definitivo è:

> `common` contiene tutto ciò che è riutilizzabile come parte di un template
> generale, cioè ciò che non dipende dalla presentazione, dalla ricerca o
> dalla terminologia specifica di Nicola.

Quindi `00_macro_common.tex` e `00_tikz_common.tex` non saranno collezioni
minime o arbitrarie. Dovranno contenere tutti gli strumenti realmente
generalizzabili, dopo averli verificati e separati dalle definizioni
specifiche. Il fatto che una definizione sia oggi usata in una figura di
Nicola non la rende automaticamente legacy: conta il suo significato e la
possibilità di riutilizzarla in altri deck.

### Quali stili sono definiti più volte

Le ridefinizioni sono nel file attuale `00_common_tikz.tex`, dentro blocchi
`\tikzset` separati. In particolare:

- `on slide` compare in più blocchi;
- `link` compare con configurazioni diverse;
- `container` compare più volte;
- `entity`, `artifact` e `service` compaiono in più sezioni, con proprietà
  diverse;
- `connector` compare più volte;
- `highlight base` e altri stili di highlighting vengono ridefiniti o
  estesi;
- `every node` viene impostato in più punti, cambiando font e allineamento.

Non significa necessariamente che Nicola abbia commesso un errore: in TikZ
più `\tikzset` possono aggiungere o aggiornare chiavi, e la definizione
successiva può prevalere su una precedente. Il problema è che il comportamento
finale dipende dall'ordine di lettura del file e non è evidente guardando un
singolo blocco.

Prima di creare `00_tikz_common.tex` bisogna quindi:

1. elencare ogni stile ripetuto;
2. confrontare tutte le proprietà assegnate;
3. verificare quali figure lo usano;
4. costruire una sola definizione common coerente, oppure mantenere nomi
   distinti quando gli stili hanno semantiche diverse;
5. compilare e verificare che l'aspetto non cambi involontariamente.

### Overlay legacy

La conversione degli overlay legacy è **in pausa** e fuori dallo scope della
separazione iniziale. Le figure di Nicola possono continuare a usare
temporaneamente i nomi `\number...` e le relative catene
`\pgfmathsetmacro`. Prima si separano e si classificano macro e stili; in una
fase successiva si valuterà la conversione alla convenzione con nomi leggibili.

### Cosa significa “compatibilità”

Per compatibilità si intende quali sorgenti devono continuare a compilare dopo
la separazione:

- la presentazione principale attuale;
- tutte le figure incluse dalle sezioni;
- gli esempi nell'appendice;
- le figure riutilizzabili nella cartella `examples/`;
- eventualmente anche materiale legacy non incluso da `main.tex`.

La decisione proposta è mantenere inizialmente la compatibilità con i primi
quattro elementi. Il materiale legacy non incluso può essere conservato, ma
non deve bloccare la progettazione del common né essere considerato parte
dell'API pubblica del template.

### Ordine delle operazioni

L'ordine della migrazione non è ancora deciso e viene lasciato aperto. Prima
si completa la classificazione concettuale; solo dopo si decide la sequenza
di separazione, compilazione e riduzione dei file.
