# Speech

# Speech: Slide 01: Title

Good morning, and thank you for being here.
Today I will present our work on security assurance for modern Big Data APIs.

# Speech: Slide 02: Context: Big Data APIs & Security Assurance

Modern Big Data systems usually do not rely on one monolithic component.
They use distributed services organized into pipelines, for tasks such as ingestion, storage, processing, and serving.
Their functionality is exposed through APIs, typically REST APIs.

The API is an important trust boundary, because every access to the pipeline and to the data it processes crosses this interface.
This interface is often exposed through an API gateway, which centralizes authentication, authorization, and rate limiting.

Existing assurance work mainly covers the pipelines and the underlying infrastructure, while the interface level is less covered.
API testing, on the other hand, usually checks functional correctness and the syntax of requests and responses.
It does not verify whether the security controls really behave as intended.
This creates an assurance gap at the API level.

And this gap has real consequences.
For example, if authorization is broken, one tenant could read the code or the configuration of another tenant's pipeline.

# Speech: Slide 03: State of the Art Limitations and Objectives

The previous slide showed why the API layer is an important part of Big Data assurance.
The next question is why existing API testing is not enough.

First, many tools focus on the syntax of requests and responses.
They can check whether a request follows the schema and whether the response is structurally valid.
However, a request can be syntactically correct and still violate a security rule.
For example, an endpoint could answer without credentials, even if the API specification says that it is protected.
The request is perfectly valid, so a syntax check does not notice anything.
This is the problem of syntactic blindness.

Second, after a test is executed, the tool must decide whether the observed behavior violates the security guarantee being tested.
This requires a criterion that defines what correct security behavior looks like and what counts as a violation.
The interface specification alone cannot always provide this criterion, because it also depends on the security control being tested.
This is the oracle problem.

Finally, existing tools are often shallow and flaky.
Shallow, because tools that work on many different APIs usually stay at the syntactic level, so they gain reach but lose depth.
Flaky, because executions are not always stable.
They can produce different results under the same conditions.
This makes the results difficult to trust in a continuous CI/CD process.

Our objectives follow these three limitations.
We want to verify the security behavior, not only the syntax.
We want an explicit rule, a specified oracle, for each security guarantee.
And we want an engine that is portable across targets and reproducible across runs.

# Speech: Slide 04: Our Approach: Overview

The core idea is simple.
We use the OpenAPI contract to build valid requests, and we use specified oracles to judge the security behavior.

The approach has four main components.
First, it is application-agnostic: the OpenAPI contract and the configuration drive the probes.
Second, it organizes the checks into eight security domains and three access levels.
Third, it gives each test a specified oracle that evaluates one security guarantee.
Finally, a deterministic engine coordinates the tests, so the results are reproducible.

The next slides explain these four components in more detail.

# Speech: Slide 05: Approach Details: Agnosticism and Contract-Driven

The first component combines application agnosticism with contract-driven probing.
The tool does not contain any code written for one specific target.
At runtime, it reads everything it needs from two sources: the OpenAPI specification and a configuration file.

The configuration file contains all the values that depend on the deployment.
For example, the concrete values for path parameters, the credentials for each role, and the thresholds.
So, to test a different service, we change the configuration file, not the code.

The OpenAPI specification then guides the probes.
It describes the endpoints and their expected inputs, so the tool can build requests that respect the declared types, formats, and constraints.
In this way, the requests are not rejected by input validation, and they really reach the application logic.
The specification also defines the documented attack surface.
But a valid request is only the first step.
Judging the security behavior is the role of the specified oracles, which we will see in a moment.

# Speech: Slide 06: Approach Details: Taxonomy and Privilege-Aware Coverage

The second component organizes the security checks into eight domains, from D0 to D7.
They go from API discovery, through authentication and authorization, to configuration hardening and business logic (separate different types of guarantees).
Each domain covers a different type of security guarantee, and the taxonomy is aligned with the NIST guidelines for cloud-native APIs.

Not every check needs the same access to the target.
So we use a gradient of three levels: black box, grey box, and white box.
Black-box tests need only network access.
For example, in D1 we check whether a protected endpoint really refuses requests without credentials.
Grey-box tests need credentials for at least two roles.
For example, in D2 we check whether user A can read the resources of user B.
White-box tests need access to the gateway configuration.
For example, in D6 we check whether the gateway really enforces a security header such as HSTS.

Each test declares the access level it requires.
If that access is not available, the test is skipped with an explicit reason, so the loss of coverage is documented and not silent.

# Speech: Slide 07: Approach Details: Specified Oracles

The third component addresses the oracle problem.
Generating a valid request is not enough.
The tool must also decide whether the observed behavior respects the security guarantee being tested.

For this reason, every test has its own specified oracle.
The oracle is built in three steps.
First, we identify the security guarantee under verification.
Second, we define what a violation of that guarantee looks like.
Third, we encode the resulting rule in the test.
The procedure is always the same; what changes from test to test is only where the rule comes from.

Let's go back to the three examples from the previous slide.
For D1, the rule comes from the security requirements in the OpenAPI specification: if an endpoint is declared as protected, but it answers with a 2xx code without credentials, this is a bypass.
For D2, the rule comes from a comparison between two roles: if user A can read a resource of user B, this is a violation.
For D6, the rule comes from the gateway configuration: if a required security header, such as HSTS, is missing, this is a violation.
In all cases, the rule describes the expected security behavior, not only the structure of the request or response.

There is also a limit.
A verdict is only as correct as the contract it is checked against.
If the specification is incomplete or wrong, the tool can reach a wrong conclusion.
For this reason, every difference from the contract is reported together with its evidence, and an analyst decides how serious it is.

# Speech: Slide 08: Approach Details: Deterministic Assessment Engine

The fourth component is the deterministic assessment engine.
Tests can declare dependencies on other tests, and the scheduler resolves them before execution.
For example, a test that checks token revocation runs only after the authentication test has produced a valid token.
In this way, the result depends on the behavior of the target, and not on the order in which tests happen to run.

Reproducibility comes from several mechanisms working together.
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

The evaluation uses Forgejo as the target service, exposed through the Kong API gateway, with PostgreSQL as the backend.
Kong runs in DB-less mode: its configuration is a read-only file, so the gateway is exactly the same at every start.
We also created three accounts, one administrator and two normal users, which we need for the grey-box tests.

We did not choose Forgejo because it is a Big Data system.
We chose it because it has the same interface properties as a Big Data service exposed through a gateway.
It has a native OpenAPI specification, distinct privilege levels, parameterized endpoints, and a gateway configuration that we can inspect for the white-box checks.
These are exactly the properties that our approach relies on.
In a Big Data platform, a service like this could be the repository where pipeline code and configuration are stored.

The testbed mixes three kinds of conditions.
Some controls were configured correctly on purpose: for example, the gateway adds the security headers to every response.
Other controls were broken on purpose: for example, rate limiting is disabled and the TLS certificate is self-signed.
Finally, other results come from the native behavior of Forgejo and Kong, which we did not configure for the test.
This allows us to check whether the assessment can distinguish violations from correct behavior.

# Speech: Slide 10: Experimental Results

We executed the assessment twice, independently, with no manual changes between the runs.
Both runs produced the same outcomes: 18 active tests in 7 domains, with 9 passes, 7 failures, 2 skips, and no errors.
This supports the reproducibility of the assessment process.
(Optional: after each run, the cleanup phase removed every resource created by the tests, so the second run started from the same state.)

These numbers do not measure how secure Forgejo is.
They show whether the tool can distinguish the two cases: the controls we broke on purpose were detected, and the controls we configured correctly passed.
(Optional: the two skips are documented skips, not errors. For example, the specification declares no deprecated endpoint, so that test has nothing to check.)

The most informative result is a discrepancy between the contract and the behavior, and it is the D1 example we saw before.
Forgejo's OpenAPI specification declares the authentication requirement at the document level, so every endpoint is declared as protected.
However, many of these endpoints answer with a 2xx code without credentials.
The specified oracle classifies this as bypassed, and reports 74 findings.

In reality, these endpoints are public by design: it is the contract that does not say so.
So this is not necessarily an exploitable vulnerability, but it is a real misalignment.
The contract is what clients rely on: if it overstates its own protections, consumers cannot know which guarantees actually hold.
This is why the tool reports the discrepancy with its evidence, and an analyst decides whether it is an intentional choice or a real vulnerability.

# Speech: Slide 11: Conclusions & Future Work

To conclude, we proposed a contract-driven approach to the security assurance of Big Data APIs.
The OpenAPI contract is used to build valid requests, and specified oracles judge the security behavior.

The evaluation showed three things.
First, the approach verifies the security behavior, not only the syntax.
Second, independent runs give the same outcomes, so the assessment can be used in a CI/CD pipeline.
Third, it found a real discrepancy between the contract and the behavior of Forgejo.

The approach also has some limits, and they guide our future work.
The oracles are written by hand, so we want to generate them automatically.
One domain of the taxonomy has no active tests yet, so we want to complete the coverage.
And we validated the approach on one target, so we want to test it on other services, for example ingestion, processing, and serving components of a Big Data pipeline.

To close: the API is where the pipelines and the data of a Big Data system are exposed.
With this work, we want to make the security of this layer something we can verify, and not only something we assume.

# Speech: Slide 12: Thanks

Thank you for your attention.
I am glad to answer your questions.
