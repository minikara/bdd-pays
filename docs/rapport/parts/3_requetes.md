# Requêtes

```{r}
library(DBI)
pays <- dbConnect(RMySQL::MySQL(), dbname="pays", username="root", password="")
```

Liste des aides sociales que perçoit un résident **X**.
- Reformultion : Liste de toutes les aides OÙ l'IdRésident = \<IdX\>
- Algèbre relationelle : $\sigma_{IdResident=<IdX>}AidesSociales$
- MySQL: SELECT \* FROM AideSociales WHERE IdResident = \<IdX\>;

```{sql, connection=pays}
SELECT * FROM AideSociale WHERE IdResident = 1
```

Combien a payé un résident en impôt depuis 10 ans
- Reformulation : Liste des montants des impôts OÙ IdRésident = \<IdX\>
ET la date est supérieur ou égale à l'année en cours -10.
(On fait la somme des montant en dehors d'une requête MySQL).
- Algèbre relationnelle :
$\pi_{montant}(\sigma_{IdResident=<IdX>}(\sigma_{date\geqq<anneeEnCours>-10}Impots))$
- MySQL : SELECT montant FROM Impots WHERE IdResident = \<IdX\> AND date = \<AnneEnCours\> - 10;

\* Il n'y a plus qu'à faire une boucle sur les montants obtenus
pour les sommer

Est-ce que la demande d'allocation chômage a été validé pour un résident donné.
- Reformulation : Etat de de l'Aides Sociales OÙ IdResident = \<IdX\> ET OÙ nom = \<Chomage\>
- Algèbre relationnelle :
$\pi_{etat}(\sigma_{IdResident=<IdX>}(\sigma_{nom='Chomage'}AidesSociales))$
- MySQL : SELECT etat FROM AidesSociales WHERE IdResident = \<IdX\> AND nom = 'Chomage';

Est ce que le résident purge actuellement une peine ?

- Reformulation : Liste des Elements du Casier Judiciaire OÙ IdResident = \<IdX\> ET peine = 'EnCoursDExecution'
( Si liste vide alors réponse non sinon réponse oui)
- Algèbre relationnelle :
$\sigma_{IdResident=<IdX>}(\sigma_{peine='EnCoursDExecution}ElementsCasierJudicaire)$
- MySQL : SELECT \* FROM ElementsCasiersJudiciaire WHERE IdResident = \<IdX\> AND peine = 'EnCoursDExecution';

\* (Possibilité de faire une projection sur une peine si on veut simplement avoir la liste des peines 'EnCoursDExecution'
cela dépend de l'usage choisit.
Afficher tous les éléments si la peine est en cours d'éxécution à l'avantage de permettre 'en savoir plus sur la dite peine).

Information sur l'extrait d'état civile d'un résident **X**
- Reformulation : Liste des attributs de Papier OÙ
IdResident=\<IdX\> ET OÙ type=EtatCivile
- Algèbre relationne :
$\sigma_{IdeResident=<IdX>}(\sigma_{type='EtatCivile'}Papier)$
- MySQL : SELECT \* FROM Papier WHERE IdResident =\<IdX\> AND type = 'EtatCivile';

Effectuer une demande de renouvellement d'un passeport
- Prérequis : Le Résident rempli un formulaire puis le soumet,
les valeurs qu'il aurat renseigné seront mises apès vérifications dans les variables :
**IdDemande**, **IdResident**, **typeDemande**, **nomDemande**, **DateDebutDemande**, **DateFinDemande**.
Le résident n'aurat en soit qu'a renseigné le type de demande qu'il souhaite faire ici **Passeport**
le reste peut être obtenu sans son intervention.
Dans tous les cas, ces informations doivent être disponible avant toute requête.
- Reformulation : Créer un nouveau Papier qui a pour valeur les valeurs des variables récupéré.
- MySQL : INSERT INTO Papier (ID, IdResident, type, nom, DateDebut, DateFin )
VALUES (IdDemande, IdResident, typeDemande, nomDemande, DateDebutDemande, DateFinDemande);
