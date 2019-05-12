# Modifications

## Dénormalisation
Toutes les relations $1..n-1..1$ peuvent
être simplifier en ajoutant dans la table $1..1$ une clef pour
accéder aux éléments de la table $1..n$. (Bonnes pratiques).
On peut donc ajouter à **Impot**, à **Papier**,
**ElementsJuridique**, et **AidesSociales** une clefs
étrangère vers **IdResident** représentant le résident auquel
l'Impot, le Papier, l'aide sociales ou l'élément juridique est
associé.

## Tableaux

Pour les tables **Papier**, **Impot** et **AidesScociales**: ajout d'un élément **etat** qui prendra
les valeurs **EnCoursDeValidation**, **Validé**, **Refusé** ou **Expiré**.

Cela va permettre pour faire une demande de Papier, Aides sociales ou une de déclaration d'impot, très simplement.
Le Résident rempli un formulaire et le soumet sur la plateforme.
La requête derriere sera simplement un insert dans la table voulu avec tous les éléments indiqués par le résident,
seulement, l'**etat** du Papier, de l'Aide Sociale ou de l'impot crée sera **EnCoursDeValidation**,
pour passer à **Validé** ou **Refusé** il faudrat qu'un administrateur la valide.

Cela permet de supprimer facilement les relations ternaires non souhaité.
Cela permet aussi de garder pendant un temps souhaité les différents éléments du dossier d'un Résident même si ceu ci sont
expiré ou sont des demandes refusé (on peut imaginer qu'après un temps ils sont supprimés de la base de données.
Ainsi par exemple si un Résident veut faie une demande de Care d'identité,
il n'a qu'a remplir le formulaire en indiquant **carte d'identé** en nom ainsi que les autres information utile,
il en découlera un insert dans la table **Papier** avec la création du papier demandé associé au formulaire,
seulement l'état du papier sera **EnCoursDeValidation** jusqu'à ce qu'un administrateur le passe en **Validé** ou **Refusé**.

Pour la table **ElementsJudicaires** : ajout d'un élément **peine** qui pourrat prendre les valeurs
**EnCoursDExecution**, **Execute**, **NonEligilible**.

La valeur **NonEligible** sera prise s'il n'y a pas lieu d'avoir une peine pour l'élément du casier. Les valeurs
**EnCoursDExecution** et **Execute** parle d'elles même et permettront ainsi un meilleure suivi de la personne et surtout de
pouvoir facilement faire la requête **Est ce qu'un résident purge actuellement une peine?**
puisqu'alors il suffit juste de sélectionner les ElementsJudiciaires correspondant à ce résident puis de egarder
les valeurs de l'élément **peine** pour chacun d'entre, si au moins l'un de à la valeur **EnCoursDExecution** la réponse sera oui.

# Requêtes

Liste des aides sociales que perçoit un résident **X**.
- Reformultion : Liste de toutes les aides OÙ l'IdRésident = \<IdX\>
- Algèbre relationelle : $\sigma_{IdResident=<IdX>}AidesSociales$
- MySQL: SELECT \* FROM AideSociales WHERE IdResident = \<IdX\>;

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
