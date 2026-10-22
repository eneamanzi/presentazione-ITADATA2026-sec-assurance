# Pianifcazione contenuto delle slide per ITADATA


## Cose da Cambiare

titolo = Security Assuance for Modern Big Data APIs

co-author: Marco Anisetti


## Scaletta

1. Titolo
2. Intro1: contesto (microservizi, gateway API, functionality ad no security)
3. Intro2: (motivations) unire i miei gaps (perchè lo stato dell'arte non basta) con gli obbiettivi, ovvero quello che vogliamo andare a fare
4. Overview Approccio: presento i componenti principali del nostro approccio
   1. Agnosticismo Applicativo e contract driven
   2. specified oracles
   3. tassonomia e box gradient
   4. pipeline di esecuzione
5. Approccio details 1
   1. Agnosticismo Applicativo e contract driven
6. Approccio details 2
   1. specified oracles
7. Approccio details 3
   1. tassonomia e box gradient
8. Approccio details processo/esecuzione
   1. pipeline di esecuzione
9. ?? OPZIONALE: esempio ??
10. Experiments
    1.  valutare se avere experiemnt setup
    2.  valutare se avere una slide a se coni risultati
11. Conclusioni e sviluppi futuri


Ricordarsi che la vecchia presentazioen è delal tesi, qua l'abbiamo riadattato al contesto big data, uindi anch eil background deve riflettere quella cosa


Contesto da abstract
Assurance of such Big Data systems has so far been addressed primarily on infrastructure and pipelines, with
comparatively less attention to the interface layer where access control and data exposure are enforced.
Automated API testing has traditionally focused on functional correctness, while security testing remains
limited. Existing approaches largely operate at the syntactic level of requests and responses, making them
ineffective at detecting vulnerabilities that stem from semantic behavior, even though such vulnerabilities account
for most of the top-ranked OWASP API security risks.


il pezzo del refenrce scenario indica appunto questo shift di contesto sulle big data api



Questi come esempi sono comodi "The correctness of its interface-level security controls directly impacts
the security of the entire platform. For example, a broken object-level authorization mechanism may
allow one tenant to access the source code or configuration of another tenant’s pipeline. Similarly, an
improperly protected hook endpoint may enable unauthorized triggering of pipeline executions, while
an endpoint that accepts requests without authentication despite being specified as protected violates
the security assumptions made by service consumers. We note that these vulnerabilities that emerge at
the semantic level of the API contract, are largelly not addressed by traditional assessments focused
mostly on the lowest layers involving pipeline code, runtime infrastructure, or network configuration."

e li possiamo colelgare al fatto che sono tutte richeiste sintatticament valide ma rompono la "semantca del contratto/comportamento atteso"

The correctness of its interface-level security controls directly impacts
the security of the entire platform. For example, a broken object-level authorization mechanism may
allow one tenant to access the source code or configuration of another tenant’s pipeline. Similarly, an
improperly protected hook endpoint may enable unauthorized triggering of pipeline executions, while
an endpoint that accepts requests without authentication despite being specified as protected violates
the security assumptions made by service consumers. We note that these vulnerabilities that emerge at
the semantic level of the API contract, are largelly not addressed by traditional assessments focused
mostly on the lowest layers involving pipeline code, runtime infrastructure, or network configuration.

tutto il punto si incentra sempre introno a questa cosa semantic correctness of API behavior



tenere in considerazione che le slide "our approach" probabilmente avranno come contenuto i pezzi del capitolo 4del paper (contract-driven API assurance) -> quindi durante al creazioen consultarlo

application agnosticism -> qua è comod da dire che appunto ad esempio tramit e il file di config si possono instrumentare alcune cose coem i valori cocnreti o spcifici di quello che si testa


contract driven probing


Configuration as the single source of variation -> la cosa ch volevo dire priam del conf con i valori concreti

Deterministic reproducibility

An Eight-Domain Assurance Taxonomy

The Assessment Engine

Oracles for Security Guarantees
questo è comdo da protaare coem logica generale "We close this gap by giving every test its own specified oracle, built with the same three-step procedure:
identify the class of guarantee under verification, determine what a violation of it looks like, and encode
the resulting rule directly in the test. What changes from test to test is only where that rule comes
from; the procedure itself never changes."

forse è comodo un esempio?

"the same system probed under
the same configuration always produces the same verdict,"
"A verdict is only as correct as the contract it is checked against. An incomplete
specification hides an endpoint from the assessment with no way to detect the omission; a specification
that misstates a requirement makes the tool praise or blame the target for the wrong reason"
"Grading how severe that divergence is falls outside the scope of
the approach, which reports it together with the evidence behind it and leaves the judgement to an
analyst."

"Application agnosticism (Section 4.1) and these specified oracles together let the tool carry its
portability across targets without leaving its security-aware evaluation logic behind, closing G3 by no
longer trading depth for reach."

experimental evaluation: test bed + design

A Discrepancy Between Contract and Behaviour

Threats to Validity

Conclusions