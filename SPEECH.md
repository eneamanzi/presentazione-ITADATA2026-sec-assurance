# Speech

## (FUORI CONTEGGIO) Messaggio mandato a nicola: IDEA GENERALE

Il concetto è che gli strumenti attuali fanno principalmente verifiche *sintattiche e funzionali*, ma nessuno guarda alla *semantica/sicurezza* di tali richieste

Ci possono essere *richieste sintatticamente perfette (che ad esempio ricevono un 2xx come risposta) che però "semanticamente" non dovrebbero ricevere*, si sta manifestando un comportamento errato

Alcuni esempi UTENTI:
- utente A accede alle risorse di B (Broken Object Level Authorization - BOLA)
- utente A utilizza webhook esterni al suo tenant (SSRF)

Alcuni esempi CREDENZIALI:
- si riceve un 2xx, ma la credenziale che mi ha fornito quel 2xx è expired/revoked/signed-valid? 
- se mando una credenziale non buona come reagisce il servizio? 
  - in questo caso si verifica il comportamento corretto della revoke e della gestione delle scadenze

Alcuni esempi GATEWAY:
- rate limiting/circuit breaker/healt-check del gateway entro certe soglie stabilite da standard

ORACOLI
E dunque gli oracoli con cui valutare ogni test vengono definiti manualmente sulla base della conoscenza del test che si sta sviluppando
- UTENTI e i permessi
  - ad esempio, si confrontano tra loro risposte di utenti con privilegi differenti e se è possibile svolgere azioni non permesse
- le CREDENZIALI
  - si confronta il codice http ricevuto con l'esito atteso, provando quindi varie combinazioni (se è scaduto e mi restituisce 2xx è un problema)
- il GATEWAY si legge la configurazione attuale e la si confronta con soglie configurabili e standard

ESPERIMENTI
ho semplicemente dimostrato che quelli che mi *aspettavo fallissero (per conf appositamente fatte male) fallivano e gli altri passavano*
In aggiunta ho casualmente notato la divergenza nella documentazione dove un sacco di endpoint sono marcati protetti ma in realtà sono pubblici, quindi di fatto un disallineamento dal contratto

DISTRIBUZIONE ESEMPI
 Context:
  A/B + expired/revoked credential + rate limiting at gateway (solo speech)
  
State of the Art:
  request without credentials → syntactically valid, security violation

Specified Oracles:
  A/B, credentials, rate limiting, SSRF as examples of different rules

## Speech: Slide 01: Title

Good morning, and thank you for being here.
My name is Enea Manzi, and today I will present “Security Assurance for Modern Big Data APIs”, co-authored with Marco Anisetti.

## Speech: Slide 02: Context: Big Data APIs & Security Assurance

Modern Big Data systems are built from distributed services that handle tasks such as data ingestion, storage, processing, and serving. 
These services are exposed through APIs and are often protected by an API gateway, which centralizes security controls.

APIs and gateways form an important trust boundary because they control access to the pipelines, the data, and the services behind them.

However, existing assurance activities mainly check infrastructure, functionality, and the syntax of requests and responses. 
**A request can be syntactically and functionally valid without respecting the expected security behavior of the API or the gateway.** (check security controls behave as expected)

For example, user A may request a resource belonging to user B.
The request can be valid, but access should still be denied.
Similarly, an expired or revoked credential can be well formed, but the service should not accept it.
The same issue can also appear at the gateway level. 
For example, the gateway may receive valid requests but fail to enforce a rate limit.

## Speech: Slide 03: State of the Art Limitations and Objectives

So why is existing API testing not enough? We see three limitations.

First, many tools check whether requests and responses are syntactically valid and whether the functional interaction succeeds. 
But this does not prove that the security behavior is correct. (it can still violate a security rule.)

For example, a request without credentials can still be a valid HTTP request, and the response can still be well formed. 
However, if the endpoint is protected, a successful response is a security violation.

This is what we mean by syntactic blindness: the request and the response may look correct, while the observed behavior violates a security rule.

Second, after a test, the tool must decide if the observed behavior matches the expected one or represents a violation.
To make this decision, the tool needs an explicit criterion based on the expected behavior of the security control being tested.
This is the oracle problem.

Third, tools are often shallow and flaky. 
They are shallow because tools that work on many APIs usually stay at the syntactic level. 
They are flaky because they can give different results under the same conditions, which is a problem in a CI/CD process.

Our objectives follow from these limitations. 
We want to verify security behavior, define a specified oracle for each guarantee, and build an engine that is portable and reproducible.

## Speech: Slide 04: Our Approach: Overview

We use the OpenAPI contract to build valid requests, and we use specified oracles to judge the security behavior.

The approach has four components.
The first is application-agnostic and contract-driven testing. 
The second is a taxonomy of eight domains with three access levels. 
The third is specified oracles. 
The fourth is a deterministic engine.

## Speech: Slide 05: Approach Details: Agnosticism and Contract-Driven

The first component combines application agnosticism with contract-driven testing.
The tool has no code written for a specific target. 
Instead, it reads everything from the OpenAPI specification and a configuration file.

The configuration file contains all the values that depend on the deployment, such as credentials and path parameters.
So, to test a different service, we change the configuration, not the code.

The OpenAPI specification defines the attack surface and guides the tests.
The tool builds requests that respect the declared types and formats, so they are not rejected by input validation and really reach the application logic.

## Speech: Slide 06: Approach Details: Taxonomy and Privilege-Aware Coverage

The second component organizes the security checks into eight domains, from D0 to D7.
Each domain covers a different type of security guarantee, from API discovery to business logic, and the taxonomy is aligned with the NIST guidelines for APIs.

Not every check needs the same level of access, so we use three levels: black box, grey box, and white box.
- Black-box tests need only network access. For example, in D1 we check whether the service refuses an expired or revoked credential.
- Grey-box tests need credentials for at least two roles. In D2 we check whether user A can read the resources of user B.
- White-box tests need access to the gateway configuration. In D4 we check whether the gateway enforces the rate limit.

Each test declares the access level it requires.
If that access is not available, the test is skipped with an explicit reason, not silently.

## Speech: Slide 07: Approach Details: Specified Oracles

The third component addresses the oracle problem.
The tool must decide whether/if the behavior respects the security guarantee.

So every test has its own specified oracle, built in three steps: 
we identify the guarantee, define what a violation looks like, and encode the rule in the test.
The procedure is always the same; only the source of the rule changes.

Let's go back to our three examples.
For D1, the rule comes from the credential rules. If the service accepts an expired or revoked credential, this is a violation.
(EXTRA: if a protected endpoint answers with a 2xx code without credentials, this is a bypass)
For D2, it comes from comparing two roles. If user A can read a resource belonging to user B, this is a violation.
For D4, it comes from the gateway configuration. If the gateway does not enforce the rate limit, this is a violation.

There is also a limit.
A verdict is only as correct as the contract it is checked against.
If the specification is incomplete or wrong, the tool can reach a wrong conclusion.
So every difference from the contract is reported with its evidence, and an analyst decides how serious it is.

## Speech: Slide 08: Approach Details: Deterministic Assessment Engine

The fourth component is the deterministic assessment engine.
Tests can declare dependencies, and the scheduler resolves them before execution.

For example, a test that checks token revocation runs only after the authentication test has produced a valid token.
In this way, the result depends on the target, and not on the order in which tests run.

Reproducibility comes from three mechanisms. 
The configuration fixes the operational parameters, the declared dependencies determine the execution order, and the oracles are fixed in advance.

As a result, the same configuration produces the same verdicts, and we can compare the outcomes across independent runs.

Finally, the engine produces a structured report and distinct exit codes. 
This allows a CI/CD pipeline to react automatically: a security violation goes to the team that owns the service, while an infrastructure problem goes to the team that runs the assessment.

## Speech: Slide 09: Experimental Setup

The evaluation uses Forgejo as the target, behind the Kong API gateway. 
We use three accounts: one administrator and two normal users for the grey-box tests.


We did not choose Forgejo because it is a Big Data system.
We chose it because it has the same interface properties as a Big Data service exposed through a gateway.

It has a native OpenAPI specification, distinct privilege levels, and a gateway configuration that we can inspect. 
These are exactly the properties our approach relies on.

The testbed combines three kinds of conditions.
- First, some controls are configured correctly, so we expect the tests to pass.
  - For example, the gateway adds the required security headers. 
- Second, some controls are deliberately misconfigured, so we expect the tests to fail. 
  - For example, rate limiting is disabled.
- Finally, some results depend on the native behavior of Forgejo and Kong.

## Speech: Slide 10: Experimental Results

Here, we compare the observed results with the expected outcomes.
A correctly configured control should pass, a deliberately broken control should fail, and a non-applicable test should be skipped.

The assessment produced 9 PASS, 7 FAIL, 2 SKIP, and 0 ERROR across 18 tests in 7 domains. 
These outcomes were identical in two independent runs.

This shows that the assessment correctly classified the expected testbed outcomes and that the execution is reproducible. 
These numbers do not measure the overall security of Forgejo.

The most informative result is our D1 example. Forgejo's specification declares authentication at the document level, so every endpoint is declared as protected. 
However, many endpoints respond with a 2xx code without credentials. 
The oracle classifies this as a bypass, with 74 findings.

In reality, these endpoints are public by design. 
The problem is that the contract does not say so. 
So this is not necessarily a vulnerability, but it is a real misalignment because clients rely on the contract.

The tool reports the discrepancy together with its evidence, and an analyst decides whether it is intentional or a real problem.

## Speech: Slide 11: Conclusions & Future Work

To conclude, we proposed a contract-driven approach to security assurance for Big Data APIs, based on specified oracles.

The evaluation showed three things. 
First, the approach verifies security behavior, not only syntax. 
Second, independent runs produce the same outcomes, so the approach can support CI/CD pipelines. 
Third, it found a real discrepancy between the contract and the observed behavior.

Our future work follows from the current limits. 
The oracles are written by hand, so we want to generate them automatically. 
We also want to complete the taxonomy and validate the approach on other Big Data services.

**An API is where pipelines and data are exposed. 
We want its security to be something we verify, not something we assume.**

## Speech: Slide 12: Thanks

Thank you for your attention.
I am glad to answer your questions.
