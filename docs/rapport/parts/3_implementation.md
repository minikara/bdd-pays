# Implémentation

## Initialisation de la base de donnée

Il s'agit de traduire le schéma relationnel en *MySQL*,
voici le fichier `db/tables.sql` permettant de créer la base de données et ses relations.

```{r, echo = FALSE}
# db/tables.sql
asis_output(paste("```sql", readr::read_file("db/tables.sql"), "```", sep="\n"))
```

Ensuite, nous avons écrit des scripts (en *python* cf. `db/data`) permettant de générer des données aléatoires mais assez pertinentes
afin de pouvoir tester nous requêtes et d'avoir un aperçu de l'application du projet.

Après avoir populé la base de données, nous avons sauvegardé les données dans des scripts MySQL
sous forme de `INSERT` pour des raisons de portabilité (cf. `db/populate`).

## Environnement

Ce rapport a été écrit en *r markdown* et ensuite traduit en LaTeX et HTML à l'aide de *knitr* et *pandoc*.
Cela pour dire qu'à partir de ce point, le code dans ce rapport a été interprété par *knitr* qui rajoute
ensuite les résultats obtenus au rapport.
Le code source est disponible sur le répértoire github [github.com/minikara/bdd-pays](https://github.com/minikara/bdd-pays).

De plus, nous avons limité les résultats affichés dans le PDF (pour des raisons de visibilité) donc nous recommandons
la lecture de cette partie sous sa forme HTML sur [minikara.github.io/bdd-pays](minikara.github.io/bdd-pays) car les résultats
sont complets et plus lisibles.

Commeçons alors par l'établissemnt de la connection avec la base de donnée à l'aide de la librairie R `DBI`

```{r}
library(DBI)
pays <- dbConnect(RMySQL::MySQL(), dbname="pays", username="root")
```

## Visualisation des relations

```{sql, connection=pays, output.var="t1"}
SELECT * FROM Resident;
```
`r my_kable(t1, f_size=4)`


```{sql, connection=pays, output.var="t2"}
SELECT * FROM Administrateur;
```
`r t2`


```{sql, connection=pays, output.var="t3"}
SELECT * FROM Autorite;
```
`r t3`


```{sql, connection=pays, output.var="t4"}
SELECT * FROM AideSociale;
```
`r t4`


```{sql, connection=pays, output.var="t5"}
SELECT * FROM Impots;
```
`r t5`


```{sql, connection=pays, output.var="t6"}
SELECT * FROM ElementJudiciaire;
```
`r t6`


```{sql, connection=pays, output.var="t7"}
SELECT * FROM Papier;
```
`r t7`

