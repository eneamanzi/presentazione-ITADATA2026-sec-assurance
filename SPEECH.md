# Speech

## Messaggio mandato a nicola molto bello con esempi pe domande

per rispondere al dubbio generale cosi capisco anche come esporlo.

Il concetto è che gli strumenti attuali fanno principalmente verifiche sintattiche e funzionali, ma nessuno guarda alla semantic/sicurezza di tali richieste
Ci possono essere richieste sintatticamente perfette (che ad esempio ricevono un 2xx come risposta) che però "semanticamente" non dovrebbero ricevere, si sta manifestando un comportamento errato

Alcuni esempi:
utente A accede alle risorse di B (Broken Object Level Authorization - BOLA)
utente A utilizza webhook esterni al suo tenant (SSRF)

oppure più banali, si riceve un 2xx, ma la credenziale che mi ha fornito quel 2xx è expired/revoked/signed-valid? se mando una credenziale non buona come reagisce il servizio? 
-> in questo caso si verifica il comportamento corretto della revoke e della gestione delle scadenze

rate limiting/circuit breaker/healt-check del gateway entro certe soglie stabilite da standard


E dunque gli oracoli con cui valutare ogni test vengono definiti manualmente sulla base della conoscenza del test che si sta sviluppando

Per gli utenti e i permessi, ad esempio, si confrontano tra loro risposte di utenti con privilegi differenti e se è possibile svolgere azioni non permesse

Per le credenziali si confronta il codice http ricevuto con l'esito atteso, provando quindi varie combinazioni (se è scaduto e mi restituisce 2xx è un problema)

Per il gateway si legge la configurazione attuale e la si confronta con soglie configurabili e standard



gli esperimenti non sono molto significativi
ho semplicemente dimostrato che quelli che mi aspettavo fallissero (per conf appositamente fatte male) fallivano e gli altri passavano
In aggiunta ho casualmente notato la divergenza nella documentazione dove un sacco di endpoint sono marcati protetti ma in realtà sono pubblici, quindi di fatto un disallineamento dal contratto

NICOLA
> Sì, come me l'hai raccontato ora è chiaro, bisogna solo applicarlo al discorso ora  ok anche gli esperimenti, quello che ti direi è: chiarisci che quello è ciò che stai valutando, una sorta di recall diciamo
> Perché il fatto era proprio che non si capisse quale fosse la metrica che stavi mostrando
 

# Speech: Slide 01: Title

Good morning, and thank you for being here.
My name is Enea Manzi, and today I will present “Security Assurance for Modern Big Data APIs”, co-authored with Marco Anisetti.

# Speech: Slide 02: Context: Big Data APIs & Security Assurance

Modern Big Data systems are not monolithic. They are built from distributed services that handle tasks such as data ingestion, storage, processing, and serving. These services are exposed through REST APIs.

The API is an important trust boundary because every access to the pipeline and its data goes through this interface.
It is often exposed through an API gateway, which centralizes authentication, authorization, and rate limiting.

Existing assurance work mainly covers functionality and the underlying infrastructure. Security at the interface level is the less covered.
API testing, on the other hand, checks functionality and syntax; it does not always check whether the security controls really work.
This creates an assurance gap at the API level.

For example, if authorization is broken, one tenant could read the code of another tenant's pipeline.

# Speech: Slide 03: State of the Art Limitations and Objectives

So why is existing API testing not enough? We see three limitations.

First, many tools only check the syntax of requests and responses.
But a request can be syntactically correct and still violate a security rule.
For example, an endpoint could respond without credentials (TODO -> bisogna fare cpaire che le credenziali mancano dalla richiesta), even if the API specification says that it is protected. 
A syntax check does not detect this. We call this syntactic blindness.

Second, after a test, the tool must decide if/whether the observed behavior is a violation. 
To do this, it needs a criterion but the specification alone cannot always provide one, because the criterion depends on the security control. 
This is the oracle problem.

Third, tools are often shallow and flaky. 
They are shallow because tools that work on many APIs usually stay at the syntactic level. 
They are flaky because they can give different results under the same conditions, which is a problem in a CI/CD process.

Our objectives follow from these limitations. 
We want to verify security behavior, define a specified oracle for each guarantee, and build an engine that is portable and reproducible.

# Speech: Slide 04: Our Approach: Overview

We use the OpenAPI contract to build valid requests, and we use specified oracles to judge the security behavior.

The approach has four components.
The first is agnostic, contract-driven probing. 
The second is a taxonomy of eight domains with three access levels. 
The third is specified oracles. 
The fourth is a deterministic engine.

# Speech: Slide 05: Approach Details: Agnosticism and Contract-Driven

The first component combines application agnosticism with contract-driven probing.
The tool has no code written for a specific target: it reads everything from the OpenAPI specification and a configuration file.

The configuration file contains all the values that depend on the deployment, such as credentials and path parameters.
So, to test a different service, we change the configuration, not the code.

The OpenAPI specification defines the attack surface and guides the tests.
The tool builds requests that respect the declared types and formats, so they are not rejected by input validation and really reach the application logic.

# Speech: Slide 06: Approach Details: Taxonomy and Privilege-Aware Coverage

The second component organizes the security checks into eight domains, from D0 to D7.
Each domain covers a different type of security guarantee, from API discovery to business logic, and the taxonomy is aligned with the NIST guidelines for APIs.

Not every check needs the same access, so we use a gradient of three levels: black box, grey box, and white box.
Black-box tests need only network access: for example, in D1 we check whether a protected endpoint refuses requests without credentials.
Grey-box tests need credentials for at least two roles: in D2 we check whether user A can read the resources of user B.
White-box tests need access to the gateway configuration: in D6 we check whether the gateway enforces the HSTS header.

Each test declares the access level it requires.
If that access is not available, the test is skipped with an explicit reason, not silently.

# Speech: Slide 07: Approach Details: Specified Oracles

The third component addresses the oracle problem.
A valid request is not enough: the tool must also decide if the behavior respects the security guarantee.

So every test has its own specified oracle, built in three steps: we identify the guarantee, we define what a violation looks like, and we encode the rule in the test.
The procedure is always the same; only the source of the rule changes.

Let's go back to our three examples.
For D1, the rule comes from the specification: if a protected endpoint answers with a 2xx code without credentials, this is a bypass.
For D2, it comes from comparing two roles: if user A can read a resource of user B, this is a violation.
For D6, it comes from the gateway configuration: if the HSTS header is missing, this is a violation.

There is also a limit.
A verdict is only as correct as the contract it is checked against.
If the specification is incomplete or wrong, the tool can reach a wrong conclusion.
So every difference from the contract is reported with its evidence, and an analyst decides how serious it is.

# Speech: Slide 08: Approach Details: Deterministic Assessment Engine

The fourth component is the deterministic assessment engine.
Tests can declare dependencies, and the scheduler resolves them before execution.
For example, a test that checks token revocation runs only after the authentication test has produced a valid token.
In this way, the result depends on the target, and not on the order of the tests.

Reproducibility comes from three mechanisms.
The configuration fixes the operational parameters, the declared dependencies determine the execution order, and the oracles are fixed in advance.
As a result, the same configuration always gives the same verdict, and the outcomes can be compared across independent runs.

Finally, the engine produces a structured report and distinct exit codes.
This allows a CI/CD pipeline to react automatically: a security violation goes to the team that owns the service, while an infrastructure problem goes to the team that runs the assessment.

## Optional details, if more time is available:
The assessment is organized into seven phases.
The first four phases are blocking: reading the configuration, validating the OpenAPI specification, building the execution context, and scheduling the tests.
The last three phases are non-blocking: running the tests, cleaning up, and producing the report.
A failure in one test is recorded as a structured result, while the other tests continue to run.
The scheduler resolves the dependencies into a topological order before execution starts.
Dependency cycles are detected before the tests run.
When several tests are ready at the same time, a lexicographic order resolves the tie deterministically.

# Speech: Slide 09: Experimental Setup

The evaluation uses Forgejo as the target, behind the Kong API gateway, with three accounts: one administrator and two normal users for the grey-box tests.
(Optional: Kong runs in DB-less mode, so its configuration is a read-only file and the gateway is the same at every start.)

We did not choose Forgejo because it is a Big Data system.
We chose it because it has the same interface properties as a Big Data service exposed through a gateway.
A native OpenAPI specification, distinct privilege levels, and a gateway configuration we can inspect: these are exactly the properties our approach relies on.
(Optional: in a Big Data platform, a service like this could be the repository where pipeline code is stored.)

The testbed mixes three kinds of conditions: some controls are correct on purpose, like the security headers; others are broken on purpose, like rate limiting; and other results come from the native behavior of Forgejo and Kong.

# Speech: Slide 10: Experimental Results

We executed the assessment twice, with no manual changes between the runs.
Both runs produced the same outcomes: 9 passes, 7 failures, 2 skips, and no errors, over 18 tests in 7 domains.
So the assessment is reproducible.
(Optional: after each run, the cleanup phase removed every resource created by the tests, so the second run started from the same state.)

These numbers do not measure how secure Forgejo is.
They show that the tool distinguishes the two cases: the controls we broke were detected, and the correct ones passed.
(Optional: the two skips are documented skips, not errors. For example, the specification declares no deprecated endpoint, so that test has nothing to check.)

The most informative result is our D1 example.
Forgejo's specification declares authentication at the document level, so every endpoint is declared as protected.
But many endpoints answer with a 2xx code without credentials: the oracle classifies them as bypassed, with 74 findings.

In reality, these endpoints are public by design: it is the contract that does not say so.
So this is not necessarily a vulnerability, but it is a real misalignment, because clients rely on the contract.
The tool reports it with its evidence, and an analyst decides if it is intentional or a real problem.

# Speech: Slide 11: Conclusions & Future Work

To conclude, we proposed a contract-driven approach to the security assurance of Big Data APIs, based on specified oracles.

The evaluation showed three things: the approach verifies security behavior, not only syntax; independent runs give the same outcomes, so it fits a CI/CD pipeline; and it found a real discrepancy between contract and behavior.

Our future work follows the current limits: the oracles are written by hand, so we want to generate them automatically; we want to complete the taxonomy; and we want to validate the approach on other Big Data services.

The API is where the pipelines and the data are exposed: we want its security to be something we verify, not something we assume.

# Speech: Slide 12: Thanks

Thank you for your attention.
I am glad to answer your questions.
