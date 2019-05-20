# Conception

## Modèle Entité/Association

Après plusieurs discussions nous avons réussi à poser les bases de notre modèle avec les différentes utilisations possibles.
Voici donc notre schéma Entité/Association final obtenu.

![Modèle Entité/Association](img/ead.png)

### Résident {-}
Le résident, comme on le voit sur le diagramme E/A, est le centre de cette application.
Il doit pouvoir générer des justificatifs des différents papiers en sa possession (justificatifs de passeport, carte de séjour, carte d’identité, permis de conduire etc.)
ainsi que des justificatifs des impôts qu’il auraient pu avoir déjà versé ainsi qu’un justificatif des aides sociales qu’il aurait pu avoir perçu.
De plus il doit également être en mesure d’effectuer des démarches pour l’obtention de ces différents papiers
et la régularisation de sa situation en faisant différentes déclarations lui permettant de payer ses impôts ou de percevoir des aides.
Ainsi le résident peut par exemple effectuer une déclaration de ses revenus qui devra être validé par un administrateur
afin qu’il puisse payer les impôts correspondant a sa situation, de même pour les aides sociales.

### Administrateur {-}
L’administrateur a pour unique rôle de vérifier les déclarations faites par le résident.
Les déclarations concernant ses revenus pour les impôts et les déclarations qu’il auraient effectué pour percevoir certaines bourses ou autres aides sociales.

### Autorité {-}
Cette entité peut consulter les informations relatives aux habitants et compléter le casier judiciaire des habitants.
Hormis le casier judiciaire des habitant, il ne peut rien modifier mais il a un droit de regard
sur toutes les informations concernant les utilisateurs enregistrés en tant que résidents.

## Liens et entités

### Papiers {-}

Un résident peut posséder déjà certains papiers, il peut en posséder plusieurs et en possède au moins un : sa carte d’identité.
De plus un papier ne peut appartenir qu’à une seule personne.
Un résident peut demander un ou plusieurs papiers et sa demande sera muni d’un formulaire.
D’où le lien « demander » entre l’entité « Résident » et l’entité « Papier » doublé d’un formulaire.
Enfin lors de sa demande de papier ou lorsqu’il consulte les papiers qu’il possède, un résident peut générer une preuve temporaire.
Par exemple s’il demande une carte européenne d’assurance maladie il peut demander de générer un papier pouvant remplacer la carte pendant une certaine durée par exemple un mois. Une preuve temporaire ne peut correspondre qu’à un seul papier mais un résident peut demander plusieurs exemplaires de preuves temporaires de papiers.

### Impôts et aides sociales {-}

Un résident peut, tout d’abord, générer une preuve ou plusieurs preuves du payements passés de ses impôts,
de plus il peut également faire une déclaration en remplissant un formulaire qui devrai être validé par un administrateur afin de pouvoir payer ses impôts.
Pour établir une déclaration afin de payer des impôts il faut qu’un Résident remplisse un ou plusieurs formulaires correspondant chacun a un impôt précis (par exemple impôt sur le revenu ), formulaires qui devront être validé par un Administrateur pour que la déclaration existe ;
Pour les aides sociales on retrouve exactement le même principe qu’avec les impôts pour comprendre cette partie il suffit donc se référer à l’explication ci-dessus

### Element judiciaire {-}

Chaque résident possède un casier judiciaire (celui peut être vide ou non).
Il peut consulter son casier judiciaire mais ne peut le modifier.
Les autorités peuvent consulter le casier judiciaire de chaque résident (comme toutes les autres informations)
mais peuvent également le compléter ci besoin en renseignant de nouvelles informations ou en supprimant certaines.

## Schéma relationnel

- Resident(**id**, email, mdp, nom, prenom, numSecu, dateNaissance, nationalite, codePostal)
- Administrateur(**id**, email, mdp, nom, prenom)
- Authorite(**id**, email, mdp, nom, prenom, tribunal)

- Papier(**id**, typePapier, nom, dateDebut, dateFin, etat, tarif, *idResident*)
- AideSociale(**id**, typeAide, frequence, montant, dateObtention, dateExpiration, etat, *idResident*, *idAdmin*)
- Impots(**id**, montant, dateDeclaration, etat, *idResident*, *idAdmin*)
- ElementJudiciaire(**id**, dateElement, typeElement, peine, *idResident*, *idAuthorite*)

![Diagramme du schéma relationnel](img/erd.png)

\pagebreak
