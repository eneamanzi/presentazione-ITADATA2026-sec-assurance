# Speech

Da riempire: una sezione per slide, con il testo da dire.

# Speech: Slide 01: Title

Good morning, and thank you for being here.
Today I will present our work on security assurance for modern Big Data APIs.

# Speech: Slide 02: Background

Modern Big Data systems usually do not rely on one monolithic component.
They use distributed services organized into pipelines for tasks such as ingestion, storage, processing, and serving.
Their functionality is exposed through APIs, typically REST APIs.

The API is an important trust boundary because every access to the pipeline and to the data it processes crosses this interface.
This interface is often exposed through a gateway that centralizes authentication, authorization, and rate limiting.

Existing assurance work mainly covers the pipeline and the underlying ecosystem, while the interface level is less covered.
API testing usually checks functional correctness and the syntax of requests and responses.
It does not necessarily verify whether the security controls behave correctly according to their intended guarantees.
This creates an assurance gap at the API level.

# Speech: Slide 03: Motivations

The previous slide showed why the API layer is an important part of Big Data assurance.
The next question is why existing API testing is not enough.

First, many tools focus on the syntax of requests and responses.
They can check whether a request follows the schema and whether the response is structurally valid.
However, a request can be syntactically correct and still violate a security rule.
This is the problem of syntactic blindness.

Second, after a test is executed, the tool must decide whether the observed behavior violates the security guarantee being tested.
This requires a criterion that defines what correct security behavior looks like and what counts as a violation.
The interface specification alone cannot always provide this criterion, because it also depends on the security control being tested.
This is the oracle problem.

Finally, an assurance process should produce stable results and should not be tied to one specific application.
Flaky executions, meaning executions that produce different results under the same conditions, make the results difficult to trust in a continuous CI/CD process.

Our objectives are therefore semantic verification, specified oracles, and an agnostic and deterministic assessment process.

# Speech: Slide 04: Our Approach: Overview

Our approach has four main components.
First, it is application-agnostic and uses the OpenAPI contract and configuration to drive the probes.
Second, it uses specified oracles to evaluate security guarantees.
Third, it organizes the checks into eight assurance domains and different access levels.
Finally, it coordinates test execution to produce reproducible results.

The next slides explain these four components in more detail.

# Speech: Slide 05: Our Approach: Details

The first component combines application agnosticism with contract-driven probing.
The tool does not contain code written for one specific target.
At runtime, it obtains the target information from the OpenAPI specification and from the configuration.

The configuration contains the values and parameters that depend on the deployment.
This keeps target-specific information outside the assessment logic.

The OpenAPI specification then guides the probes.
It describes the documented endpoints and their expected inputs, so the tool can construct requests that respect the declared types, formats, and constraints.
It also defines the documented assessment surface and provides a structural criterion for evaluating the responses.
This structural evaluation is different from checking the semantic security guarantees, which is the role of the specified oracles.

# Speech: Slide 06: Taxonomy and Privilege-Aware Coverage

The second component organizes the security checks into eight domains.
These domains separate different types of guarantees, such as authentication, authorization, data integrity, and configuration hardening.

The required access also depends on the test.
Black-box tests need only network access.
Grey-box tests use credentials for distinct roles, for example to compare their permissions.
White-box tests require access to the gateway configuration plane.

Each test declares the access strategy it requires.
If that access is not available, the test is skipped with an explicit reason rather than silently reducing the coverage.

# Speech: Slide 07: Specified Oracles

The third component addresses the oracle problem.
Generating a valid request is not enough.
The tool must also decide whether the observed behavior respects the security guarantee being tested.

For this reason, every test has its own specified oracle.
The oracle is built in three steps.
First, we identify the security guarantee under verification.
Second, we define what a violation of that guarantee looks like.
Third, we encode the resulting rule in the test.

The criterion can come from the API specification, an external standard, or a comparison between responses obtained with different roles.
The important point is that it describes the expected security behavior, not only the structure of the request or response.

There is also an epistemic limit.
A verdict is only as sound as the contract it is checked against.
If the specification is incomplete or incorrect, the assessment may reach the wrong conclusion for the wrong reason.

# Speech: Slide 08: Deterministic Assessment Engine

The fourth component is the deterministic assessment engine.
Tests can declare dependencies on other tests, and the scheduler resolves them before execution.
This ensures that a test is run only when its required preconditions are available.

Reproducibility comes from several mechanisms working together.
The configuration fixes the operational parameters, the declared dependencies determine the execution order, and the oracles are fixed in advance.
As a result, the relevant outcomes can be compared across independent runs.

The engine also produces structured results and distinct exit codes.
This allows a CI/CD pipeline to distinguish a security violation from an execution or infrastructure problem.

## Optional details, if more time is available:
The assessment is organized into seven phases.
The first four phases are blocking: reading the configuration, validating the OpenAPI specification, building the execution context, and scheduling the tests.
The last three phases are non-blocking: running the tests, cleaning up, and producing the report.
A failure in one test is recorded as a structured result, while the other tests continue to run.
The scheduler resolves the dependencies into a topological order before execution starts.
Dependency cycles are detected before the tests run.
When several tests are ready at the same time, a lexicographic order resolves the tie deterministically.

# Speech: Slide 09: Experimental Setup

The evaluation uses Forgejo as the target service, exposed through the Kong API gateway.
PostgreSQL provides the persistence backend.

The testbed was selected because it exposes the properties needed for the evaluation.
It provides an OpenAPI specification, distinct privilege levels, parameterized endpoints, and gateway configuration that can be inspected for white-box checks.

The setup includes both expected successes and deliberately broken controls.
This allows us to check whether the assessment can distinguish the two cases.

# Speech: Slide 10: Experimental Results

We executed the assessment twice independently.
Both runs produced the same outcomes across 18 active tests in 7 domains.
The results were 9 passes, 7 failures, 2 skips, and no errors.
The testbed was configured to include both expected successes and deliberately broken controls, so these results show that the engine can distinguish the two cases.

The most informative result is a discrepancy between the API contract and the observed behavior in Forgejo.
Forgejo's OpenAPI specification declares the authentication requirement at the document level, and the analyzer applies it to the endpoints.
However, some of those endpoints accept requests without credentials.
The specified oracle classifies this behavior as bypassed and reports a contract discrepancy.

This result does not by itself establish that the behavior is an exploitable vulnerability.
It establishes that the observed behavior does not match the guarantee declared in the contract.
This matters because the contract is supposed to be a source of truth for clients and for future verification.
If the service behaves differently from that contract, consumers cannot reliably reason about which security guarantees are actually enforced.

This supports the reproducibility of the assessment process.

# Speech: Slide 11: Conclusions

To conclude, this paper addresses security assurance at the API level of Big Data services.
The approach uses the OpenAPI contract to build valid probes, while specified oracles evaluate the security meaning of the observed behavior.
The eight-domain taxonomy organizes the checks, and the deterministic engine makes the results reproducible.

The evaluation showed that the approach can distinguish enforced guarantees from violations, including a discrepancy between the published contract and the observed behavior.
This answers the three research questions about semantic verification, reproducibility, and the detection of unexpected misalignments.

For future work, we plan to complete the coverage of the taxonomy and add adapters for managed cloud API gateways.
We also want to develop reliable methods for generating security oracles automatically instead of authoring every rule manually.

# Speech: Slide 12: Thanks

Thank you for your attention.
I am glad to answer your questions.
