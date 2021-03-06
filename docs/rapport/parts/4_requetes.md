## Requêtes


### Liste des aides sociales que perçoit un résident donné. {-}

- **Reformultion :** Liste de toutes les aides **où** idResident = *X*
- **Algèbre relationelle :** $$\sigma_{\text{idResident}=<X>}(\text{AideSociale})$$
- **SQL:** On donne une valeur pour $X$
```{r}
X <- 44
```
```{sql, connection=pays, output.var="q1"}
SELECT * FROM AideSociale WHERE idResident = ?X;
```
`r q1`

### Combien chaque résident a payé en impôt sur les derniers 10 ans ? {-}

- **Reformulation :**
    + Liste d'impôts *Validés* **où** la date est $\geq$ année en cours $-10$ (sélections)
    + Le montant payé (projection)
    + La somme des montants de la liste par résident (fonction agrégation)
- **Algèbre relationnelle :**
$$ I = \pi_{\text{montant, idResident}}(\sigma_{\text{date}\geq<\text{AnnéeEnCours}>-10\quad\wedge\quad\text{etat="valide"}}(\text{Impots})) $$
Afin d'obtenir la somme, nous n'avons qu'à faire: ${}_\text{idResident}\gamma_{\text{somme}(\text{montant})}(\sigma_{\text{idResident}=<X>}(I))$
- **SQL :**

```{sql, connection=pays, output.var="q2"}
SELECT R.id, R.nom, R.prenom, R.nationalite, SUM(montant) FROM Impots, Resident R
    WHERE etat = "Valide"
    AND idResident = R.id
    AND dateDeclaration >= YEAR(CURDATE()) - 10
    GROUP BY idResident;
```
`r q2[1:min(25,nrow(q2)),]`

Si on cherche pour un résident en particulier, il suffit de faire
$$ \gamma_{\text{somme(montant)}} (\sigma_\text{idResident=<X>}(I))$$

```{sql, connection=pays, output.var="q3"}
SELECT SUM(montant) FROM Impots
    WHERE etat = "Valide"
    AND idResident = ?X
    AND dateDeclaration >= YEAR(CURDATE()) - 10;
```
`r q3`

### Est-ce que la demande d'allocation RSA a été validé pour un résident donné ? {-}

- **Reformulation :** état de l'aide sociale **où** idResident = *X* **et** typeAide = "RSA"
- **Algèbre relationnelle :**
$$\pi_{\text{etat}}(\sigma_{\text{idResident}=<X>}(\sigma_{\text{typeAide}=\text{"RSA"}}(\text{AideSociale})))$$
- **SQL :**
```{sql, connection=pays, output.var="q4"}
SELECT etat FROM AideSociale
    WHERE idResident = ?X
    AND typeAide = "RSA";
```
`r q4`

### Est ce que tel résident purge actuellement une peine ? {-}

- **Reformulation :**
    + liste des elements du casier judiciaire **où** idResident = *X* **et** peine est en cours d'exécution.
    + si la liste est vide alors la réponse est "non" sinon "oui"
- **Algèbre relationnelle :**
$$\sigma_{\text{idResident}=<X>}(\sigma_{\text{peine}=\text{"EnCoursDExecution"}}(\text{ElementJudicaire})$$
- **SQL :**
```{sql, connection=pays, output.var="q5"}
SELECT * FROM ElementJudiciaire
    WHERE idResident = ?X
    AND peine = "EnCoursDExecution";
```
`r q5`

\* (Possibilité de faire une projection sur une peine si on veut simplement avoir la liste des peines 'EnCoursDExecution'
cela dépend de l'usage choisit.
Afficher tous les éléments si la peine est en cours d'exécution à l'avantage de permettre d'en savoir plus sur la dite peine).

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

Dans notre vision de cette application il s'agit d'une procédure qui ne demande pas l'intervention d'un *Administrateur*
car toutes les informations nécessaires sont déjà dans cette base de données.
Par exemple, en supposant qu'un citoyen qui purge une peine n'a pas le droit d'obtenir un passeport
il s'agit donc de faire la requête précédente.
Pour le cas d'un passeport, le tarif et la durée sont déjà fixés, il reste plus qu'à remplir la base de donné par
ces informations récupérées.
Une instance sera donc créée avec l'état "EnCoursDeValidation" jusqu'à la vérification du paiement.
```sql
INSERT INTO Papier (idResident, typePapier, dateDebut, dateFin, etat, tarif)
VALUES (?X, "passeport", CURRENT_DATE(), CURRENT_DATE() + 10, "EnCoursDeValidation", 86);
```

### Lister tout les administrateur dans l'ordre de nombre de tâches dont ils sont chargés {-}

On voudrait étendre la relation Administrateur en y rajoutant le nombre de tâches dont chaque
administrateur est chargé actuellement, cette requête est très utile dans le cas où on voudrait automatiser
l'attribution des tâches.

**Petite remarque:** on aurait pu rendre l'application plus réaliste en rajoutant un champs *disponibilité*
qui indiquera si l'employé est disponible ou pas (en arrêt maladie, congé maternel/paternel, vacances, etc),
ce qui exclura les employés non disponible des résultats de cette requête.

Plongeons nous alors dans cette requête !

- Un administrateur est chargé d'examiner les demandes d'aides sociales et des déclarations d'impots,
on voudrais donc d'abord séléctionner tous les éléments de ces deux relations
dont l'état est *en cours de validation*.
- Ensuite, on fait une jointure externe gauche entre Administrateur et la relation obtenue.
- A l'aide de la fonction d'agrégation de comptage, on compte le nombre d'occurances par administrateur.

$$ T = \pi_{\text{id,idAdmin}}(\sigma_{\text{etat="EnCoursDeValidation"}}(\text{AideSociale}))\cup\pi_\text{id,idAdmin}(\sigma_{\text{etat="EnCoursDeValidation"}}(\text{Impots}))$$
$$ {}_{\text{id}}\gamma_{\text{compter(T.id)}}(\text{Administrateur}\underset{\text{id=T.idAdmin}}{⟕}T)$$

```{sql, connection=pays, output.var="q6"}
SELECT Administrateur.id, email, nom, prenom, COUNT(ALL T.id) as nbTaches
FROM Administrateur
LEFT OUTER JOIN (
    SELECT id, idAdmin FROM AideSociale WHERE etat = "EnCoursDeValidation"
    UNION ALL SELECT id, idAdmin FROM Impots WHERE etat = "EnCoursDeValidation"
) AS T ON T.idAdmin = Administrateur.id
GROUP BY Administrateur.id
ORDER BY nbTaches;
```
`r q6`

### Donner pour chaque aide sociale attribuée le montant total reçu {-}

Afin de calculer le montant reçu pour une aide sociale il faut prendre en compte
sa fréquence, sa date d'obtention et sa date d'expiration.

En effet, on introduit une fonction **M(m,f,deb,fin)** qui calcule le montant total où:

- **m:** montant unitaire.
- **f:** fréquence qui prend l'une des valeurs (annuelle, monsuelle, ou poncuelle).
- **deb:** date d'obtention de l'aide.
- **fin:** date de fin de l'aide.

$$ A_T = {}_\text{id} \gamma_\text{M(montant, frequence, dateObtention, dateExpiration)}(\text{AideSociale}) $$

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

```{sql, connection=pays, output.var="q7"}
SELECT AideSociale.id, typeAide, frequence, montant, montantTotal,
    dateObtention, dateExpiration, idResident
FROM AideSociale, AideTotale
WHERE AideSociale.id = AideTotale.id;
```
`r q7`

### Combien chaque résident reçoit en aides sociales ?

On reprend la vue qu'on vient de créer, et ensuite on fait la somme par résident.

- Jointure interne de AideTotale et AideSociale sur le *id*
- Jointure interne avec le résident sur *idResident*
- La somme des montants totaux groupés par résident

**Remarque:** on aurait pu mettre tous les champs de la relation AideSociale
dans la vue AideTotale ce qui nous évitera de faire la première jointure.
On justifie notre choix par le fait qu'on a préféré obtenir une vue minimale.

$$ {}_\text{R.id} \gamma_\text{somme(montantTotal)}(\text{Resident}\underset{\text{R.id=idResident}}{\bowtie}(\text{AideSociale}\underset{\text{id}}{\bowtie}A_T))$$

On rajoute le nom, prénom, et la nationalité du résident pour mieux visualiser.
```{sql, connection=pays, output.var="q8"}
SELECT R.id, R.nom, R.prenom, SUM(ALL montantTotal) as total, R.nationalite
FROM AideTotale, AideSociale
INNER JOIN Resident R on AideSociale.idResident = R.id
WHERE AideTotale.id = AideSociale.id
GROUP BY R.id
ORDER BY total DESC;
```
`r q8`

### Combien on donne au non-français en aides sociales ?

Similairement à la requête précédante, on utilise la vue AideTotale

- Jointure interne de AideTotale et AideSociale sur le *id*
- Jointure interne avec le résident sur *idResident*
- La somme des montants totaux **où** résident est non français.

$$ \gamma_\text{somme(montantTotal)}(\sigma_{\text{nationalite}\neq\text{"France"}}(\text{Resident}\underset{\text{R.id=idResident}}{\bowtie}(\text{AideSociale}\underset{\text{id}}{\bowtie}A_T)))$$

```{sql, connection=pays, output.var="q9"}
SELECT SUM(ALL montantTotal) AS total
FROM AideTotale, AideSociale
INNER JOIN Resident R on AideSociale.idResident = R.id
WHERE AideTotale.id = AideSociale.id
AND R.nationalite <> "France"
```
`r q9`

Il est aussi intéressant de regrouper les montants par nationalité (pour les montants non-nuls).

$$\sigma_{\text{total}\neq 0}({}_\text{nationalite} \gamma_\text{somme(montantTotal)}(\sigma_{\text{nationalite}\neq\text{"France"}}(\text{Resident}\underset{\text{R.id=idResident}}{\bowtie}(\text{AideSociale}\underset{\text{id}}{\bowtie}A_T))))$$

```{sql, connection=pays, output.var="q10"}
SELECT R.nationalite, SUM(ALL montantTotal) AS total
FROM AideTotale, AideSociale
INNER JOIN Resident R on AideSociale.idResident = R.id
WHERE AideTotale.id = AideSociale.id
GROUP BY R.nationalite
HAVING total > 0;
```
`r q10`
