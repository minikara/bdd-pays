# Requêtes

```{r}
library(DBI)
pays <- dbConnect(RMySQL::MySQL(), dbname="pays", username="root", password="")
```

On initialise la valeur test suivante:
```{r}
X <- 44
Y <- 77
```

### Liste des aides sociales que perçoit un résident donné. {-}

- **Reformultion :** Liste de toutes les aides **où** idResident = *X*
- **Algèbre relationelle :** $$\sigma_{\text{idResident}=<X>}(\text{AideSociale})$$
- **SQL:**

```{sql, connection=pays}
SELECT * FROM AideSociale WHERE idResident = ?X;
```

### Combien chaque résident a payé en impôt sur les derniers 10 ans ? {-}

- **Reformulation :**
    + Liste d'impôts *Validés* **où** la date est $\geq$ année en cours $-10$ (sélections)
    + Le montant payé (projection)
    + La somme des montants de la liste par résident (fonction agrégation)
- **Algèbre relationnelle :**
$$ I = \pi_{\text{montant, idResident}}(\sigma_{\text{date}\geq<\text{AnnéeEnCours}>-10\quad\wedge\quad\text{etat="valide"}}(\text{Impots})) $$
Afin d'obtenir la somme, nous n'avons qu'à faire: ${}_\text{idResident}\gamma_{\text{somme}(\text{montant})}(\sigma_{\text{idResident}=<X>}(I))$
- **SQL :**

```{sql, connection=pays}
SELECT R.id, R.nom, R.prenom, R.nationalite, SUM(montant) FROM Impots, Resident R
    WHERE etat = "Valide"
    AND idResident = R.id
    AND dateDeclaration >= YEAR(CURDATE()) - 10
    GROUP BY idResident;
```

Si on cherche pour un résident en particulier, il suffit de faire
$$ \gamma_{\text{somme(montant)}} (\sigma_\text{idResident=<X>}(I))$$
```{sql, connection=pays}
SELECT SUM(montant) FROM Impots
    WHERE etat = "Valide"
    AND idResident = ?X
    AND dateDeclaration >= YEAR(CURDATE()) - 10;
```

### Est-ce que la demande d'allocation RSA a été validé pour un résident donné ? {-}

- **Reformulation :** état de l'aide sociale **où** idResident = *X* **et** typeAide = "RSA"
- **Algèbre relationnelle :**
$$\pi_{\text{etat}}(\sigma_{\text{idResident}=<X>}(\sigma_{\text{typeAide}=\text{"RSA"}}(\text{AideSociale})))$$
- **SQL :** SELECT etat FROM AidesSociales WHERE IdResident = \<IdX\> AND nom = 'Chomage';
```{sql, connection=pays}
SELECT etat FROM AideSociale
    WHERE idResident = ?X
    AND typeAide = "RSA";
```

### Est ce que tel résident purge actuellement une peine ? {-}

- **Reformulation :**
    + liste des elements du casier judiciaire **où** idResident = *X* **et** peine est en cours d'exécution.
    + si la liste est vide alors la réponse est "non" sinon "oui"
- **Algèbre relationnelle :**
$$\sigma_{\text{idResident}=<X>}(\sigma_{\text{peine}=\text{"EnCoursDExecution"}}(\text{ElementJudicaire})$$
- **SQL :**
```{sql, connection=pays}
SELECT * FROM ElementJudiciaire
    WHERE idResident = ?X
    AND peine = "EnCoursDExecution";
```

\* (Possibilité de faire une projection sur une peine si on veut simplement avoir la liste des peines 'EnCoursDExecution'
cela dépend de l'usage choisit.
Afficher tous les éléments si la peine est en cours d'éxécution à l'avantage de permettre 'en savoir plus sur la dite peine).

<!--
Informations sur l'extrait d'état civile d'un résident *X*

- **Reformulation :** Liste des attributs de Papier OÙ
IdResident=\<IdX\> ET OÙ type=EtatCivile
- Algèbre relationne :
$$\sigma_{IdeResident=<IdX>}(\sigma_{type='EtatCivile'}Papier)$$
- **SQL :** SELECT \* FROM Papier WHERE IdResident =\<IdX\> AND type = 'EtatCivile';
```{sql, connection=pays}
SELECT * FROM AideSociale;
```
-->

### Effectuer une demande de renouvellement d'un passeport {-}

Dans notre vision de cette application il s'agit d'un procédure qui ne demande pas l'intervention d'un *Administrateur*
car toutes les informations nécessaires sont déjà dans cette base de donnée.
Par exemple, en supposant qu'un citoyen qui purge une peine n'a pas le droit d'obtenir un passeport
il s'agit donc de faire la requête précédente.
Pour le cas d'un passeport, le tarif et la durée sont déjà fixés, il reste plus qu'à remplir la base de donné par
ces informations récupérées.
Une instance sera donc créée avec l'état "EnCoursDeValidation" jusqu'à la vérification du paiement.
```sql
INSERT INTO Papier (idResident, typePapier, dateDebut, dateFin, etat, tarif)
VALUES (?X, "passeport", CURRENT_DATE(), CURRENT_DATE() + 10, "EnCoursDeValidation", 86);
```

### Lister tout les administrateur dans l'ordre de nombre de tâches dont ils sont chargé {-}

On voudrait étendre la relation Administrateur en y rajoutant le nombre de tâches dont chaque
administrateur est chargé actuellement, cette requête est très utile dans le cas où on voudrait automatiser
l'attribution des tâches.

**Petite remarque:** on aurait pu rendre l'application plus réaliste en rajoutant un champs *disponibilité*
qui indiquera si l'employé est disponible ou pas (en arrêt maladie, congé maternel/paternel, vacances, etc),
ce qui exclura les employés non disponible des résultats de cette requête.

Plongeons nous alors dans cette requête !

Un administrateur est chargé d'examiner les demandes d'aides sociales et des déclarations d'impots,
on voudrais donc d'abord séléctionner tous les éléments de ces deux relations
dont l'état est *en cours de validation*.

La suite de la requête diffère un peu entre l'algèbre relationnel et MySQL;
notre première approche était de faire une jointure externe entre la relation obtenue
et la relation Administrateur, en d'utiliser ensuite la fonction d'agrégation de comptage par groupe.

$$ T = \sigma_{\text{etat="EnCoursDeValidation"}}(\pi_{\text{id,idAdmin}}(\text{AideSociale})\cup\pi_\text{id,idAdmin}(\text{Impots}))$$

$$ {}_{\text{idAdmin}}\gamma_{\text{compter(id)}}(\text{Administrateur}\underset{\text{idAdmin}}{⟕}T)$$

```{sql, connection=pays}
SELECT id, email, nom, prenom, nbTaches from Administrateur LEFT JOIN (
    SELECT COUNT(ALL id) AS nbTaches, idAdmin FROM (
        SELECT id, idAdmin FROM AideSociale WHERE etat = "EnCoursDeValidation"
        UNION ALL SELECT id, idAdmin FROM Impots WHERE etat = "EnCoursDeValidation"
    ) AS tUnion
    GROUP BY idAdmin
) AS tCount ON tCount.idAdmin = Administrateur.id;
/*ORDER BY nbTaches;*/
```

### Donner pour chaque aide sociale attribuée le montant total reçu {-}

```{sql, connection=pays}
DROP VIEW IF EXISTS AideTotale;
```
```{sql, connection=pays}
CREATE VIEW AideTotale AS
SELECT id,
    CASE frequence
        WHEN 'a' THEN montant * (timestampdiff(year, dateObtention, dateExpiration))
        WHEN 'm' THEN montant * (timestampdiff(month, dateObtention, dateExpiration))
        ELSE montant
    END AS montantTotal
FROM AideSociale;
```

```{sql, connection=pays}
SELECT AideSociale.id, typeAide, frequence, montant, montantTotal, dateObtention, dateExpiration, idResident
FROM AideSociale, AideTotale
WHERE AideSociale.id = AideTotale.id;
```