# Piano di revisione slide + speech (ITADATA 2026)

Obiettivo: allineare slide e SPEECH.md al paper, sfoltire il testo delle slide
(il testo tolto va nello speech e resta come commento `%` nel LaTeX), durata ~12 minuti.
Si lavora solo nella cartella della presentazione. Si procede slide per slide.

## Decisioni generali

- **Ordine dei componenti**: agnosticism → taxonomy (+ privilege-aware coverage) → oracles → engine.
  Da uniformare in: slide 4 (overview), speech overview, slide di dettaglio, CONTENUTO.md.
- **Titoli SPEECH.md** = titoli dei frame: "Our Approach: Overview", poi "Approach Details: ...".
  Togliere la riga "Da riempire..." in cima.
- **Research Questions**: non vanno in slide. Non nominare "RQ" nemmeno nello speech
  (togliere "This answers the three research questions"). Le conclusioni dicono cosa abbiamo mostrato.
- **"same outcomes"**, mai "byte-identical" (timestamp e ID cambiano tra le run, vedi paper §5.4).
- **Grassetto** solo per le etichette.
- **`\alert{}`** sulle parole chiave (anche più di una per slide), mai su frasi intere.
  Controllare sul PDF che il colore alert del tema (Goldenrod, oro scuro) si legga bene.
- **Macro per i colori PASS/FAIL/SKIP**: solo se riusati in più di una slide (da valutare).
- **Tempi**: niente ripartizione rigida; si verifica il totale (~12') alla fine.
  Speech attuale ≈ 1.280 parole ≈ 10–10,5' → c'è spazio per ~150–200 parole in più.

## Contenuti da aggiungere / correggere (soprattutto nello speech)

- **Forgejo e Big Data** (speech, slide setup): una frase onesta. Lo abbiamo scelto non perché è
  un sistema Big Data, ma perché ha le stesse proprietà di interfaccia (contratto OpenAPI nativo,
  controllo accessi sul gateway, ruoli distinti), che sono quelle che l'approccio verifica.
- **Esempi dello scenario** (solo speech, slide Context): due esempi, cioè un tenant che legge la
  pipeline di un altro tenant, e un endpoint dichiarato protetto che risponde senza credenziali
  (il secondo anticipa il risultato chiave).
- **Gap**: la slide 3 deve coprire anche G3 (portabilità vs profondità).
- **Gateway inspection**: aggiungerla nello speech degli oracoli tra le fonti del criterio.
- **Risultato chiave, detto onestamente**: gli endpoint sono pubblici per scelta, è il contratto
  a non dirlo. Si segnala la divergenza; se è un problema reale lo decide un analista.
- **I conteggi misurano la capacità di distinguere, non la sicurezza di Forgejo** (speech results).
- **SKIP**: sono skip documentati, non errori (mezza frase, opzionale).
- **7 domini**: D5 non ha test attivi (mezza frase, opzionale).
- **Teardown/idempotenza**: mezza frase opzionale nei results.
- **Limiti → future work** nelle conclusioni (oracoli manuali, white-box non disponibile su
  cloud gestiti, un solo target).
- **Speech results**: spostare "This supports the reproducibility..." subito dopo
  "Both runs produced the same outcomes".

## Slide per slide

| # | Slide | Decisione |
|---|---|---|
| 2 | Context | **FATTA** (frame + speech): 4 punti "etichetta:" accorciati, alert sulle parole chiave, i 2 esempi dello scenario nello speech. |
| 3 | Limitations / Objectives | **FATTA**: 3 righe, la terza è "Shallow & Flaky Tools" → "Agnostic & Deterministic". Alert solo sugli obiettivi. Esempio dell'endpoint "protetto" nello speech. |
| 4 | Overview | **FATTA**: titolo "Our Approach: Overview", righe sotto i punti tolte, nuovo ordine, alert sui nomi dei componenti e sulla Core Idea (approvata così). |
| 5 | Agnosticism | **FATTA**: titolo "Approach Details: Agnosticism and Contract-Driven", 3 punti corti, riga sulla configurazione "all target-specific values live in one file". |
| 6 | Taxonomy | **FATTA**: a sinistra tabella D0–D7 (righe distanziate) con D1, D2, D6 in alert; a destra (2° click) "Privilege-Aware Box Gradient": Black/Grey/White + domanda d'esempio in corsivo (D1, D2, D6). Cosa serve per ogni livello solo nello speech. Dipendenze D0→D1→D2 fuori. |
| 7 | Oracles | **FATTA (da rivedere)**: frase sullo "specified oracle", 3 passi su una riga con frecce, tabella (2° click) D1/D2/D6 con la fonte del criterio e la violazione. Limite epistemico + "decide un analista" solo nello speech. |
| 8 | Engine | **FATTA (da rivedere)**: 3 punti corti, etichette originali (Dependency-Aware Scheduling / Reproducible Assessment / Actionable Output), alert su prerequisites, "same configuration, same verdict", security violation. Speech: esempio della revoca del token, exit code → chi riceve il problema. Parte opzionale invariata. |
| 9 | Setup | **FATTA (da rivedere)**: struttura A. Sinistra "Target and gateway" + "3 accounts: admin + 2 users"; destra "Interface properties", con il sottotitolo "shared by Big Data services behind a gateway" e alert sulle proprietà. In fondo, al 2° click (`\uncover<2->`), "The testbed combines:" con 3 righe (Expected success / Deliberately broken / Native behavior), un esempio ciascuna. Evitare frasi assolute sul comportamento nativo ("other outcomes", non "everything else"). Speech: DB-less, frase onesta su Forgejo, possibile ruolo di repository. |
| 10 | Results | **FATTA (da rivedere)**: 2 passi. (1) run + conteggi insieme (numeri lining); (2) box "Key result: Contract vs. Behavior (D1)" in forma schematica Spec/Observed/Verdict (riprende la riga D1 della slide 7) + "Public by design: the contract is wrong → an analyst decides". Speech: riproducibilità dopo le run, "discrimination, not posture", endpoint pubblici per scelta, teardown e SKIP opzionali. |
| 11 | Conclusions | **FATTA (da rivedere)**: 4 punti (cosa abbiamo fatto + 3 risultati), Future Work al 2° click: oracoli automatici, completare la tassonomia, altri target. Speech: limiti a voce legati uno a uno ai future work, chiusura che riprende l'inizio. |

## Tempi (dopo il primo giro)

Speech ≈ 1.930 parole (senza le parti opzionali) ≈ 15–16 minuti → troppo lungo.
Obiettivo ≈ 1.450–1.500 parole (~12'). Da tagliare ~450 parole, soprattutto nelle slide 3, 7, 9, 10.

## Aperti

- Numeri old-style del font (Fira Sans): decisione = restano old-style nel deck (graficamente vanno bene).
  Solo nelle colonne con "D0".."D7" (slide 6 e 7) si usa `\addfontfeatures{Numbers=Lining}`, perché "D0" sembrava "Do".
- Colore alert: risolto, `Goldenrod!75!black` in `00_macro_project.tex`.
- Testi definitivi delle slide 8–11.
