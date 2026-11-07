# 2. Context
- distributed services are exposed through APIs, often behind a gateway
- trust boundary -> API & gateway are the entry point to functionalities
- Assurance gap -> check functionality and syntax of req/res -> no behavior
  - A request can be syntactically and functionally valid without respecting the expected security behavior of the API or the gateway
- A read B -> valid request but wrong behavior
- expired/revoked -> valid request, should be rejected

# 3. Limitations + Objectives
- syntactic blindness: syntactically and functionally valid -> doesn't prove correct security behavior
  - valid request without credential get 2xx on a protected endpoint -> violation
- criterion, based on the control being tested, to judge observed behavior
  - specified oracles
- shallow -> work on many APIs -> stay at syntactic level
- flaky -> different result under same cond
  - agnostic and deterministic/reproducible

# 4. Overview
- OAPI -> valid request & Specified oracles -> security behavior
-  application agnosticisim + contract driven
-  taxonomy + box gradient
-  secified oracles
-  deterministic engine

# 5. Agnostic + contract driven
- no target specific code (conf + OAPI spec)
- configuration contains everything valuable, change conf
- OAPI spec used to define attack surface + build valid request 

# 6. Taxonomy + box gradient
- 8-domain taxonomy alligned with NIST APIs's guidelines
  - each domain a different type of security guarantee
- BLACK -> network access -> expired/revoked
- GREY  -> credential 2 roles -> A read B
- WHITE -> gateway conf -> rate limiting

# 7. Specified Oracles
- specified oracles to judge if behavior respects security guarantee
  - guarantee -> violation -> encode
- Authentication -> expired/revoked -> violation
- Authorization -> A read B -> role comparison
- Availability -> no rate limiting -> gateway conf

# 8. Deterministic Assessment Engine
- prerequisites fix execution order
  - i.e. authentication before authorization
- configuration only source of variation -> if fixed (same verdict), reproducible run
- semantic exit codes for CI/CD -> pipeline react

# 9. Experimental Setup
- Forgejo + KONG -> interface properties our approach targets (common in Big Data services)
  - OAPI spec + privilege levels + gateway conf
- Test Bed
  - Success -> correctly configured -> i.e. gateway header
  - Failure -> intentioanly broken -> i.e. rate limiting
  - Native -> some other result

# 10. Experimental Results
- compared observed results with expected outcomes
  - ability to distinguish the expected outcomes
  - tests correctly classified testbed cases
- many endpoint respond, without credentail in the request, while being declared protected
  - public by design, but the contract does not say so. -> real misalignment
  - analyst will judge their severity and exploitability

# 11. Conclusion + Future Work
- contract-driven approach to security assurance based on specified oracles
  - secuirty behavior
  - deterministic -> CI/CD
  - real contract discrepancy
- automate oracle generation + other target for validation

- We want API security to be something we verify, not something we assume