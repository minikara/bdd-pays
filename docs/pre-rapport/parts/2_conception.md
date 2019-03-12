# Conception

## Modèle Entité/Association

Après plusieurs discussions nous avons réussi a poser les bases de notre modèle avec les différentes utilisations possibles.
Le but de cette partie et de décrire précisément les différentes opérations possibles par les différents acteurs de la plateforme.

![Modèle Entité/Association](img/erd_admin.png)

## Utilisateurs

Trois types d'utilisateur différents pourraient utiliser la base de données : un résident, un administrateur (chargé de vérifier les différentes déclarations des résidents afin de vérifier leur véridicité) et un représentant de l’autorité pouvant consulter les données relative à chaque habitant.

### Résident {-}
Le résident doit tout d’abord pouvoir s’authentifier puis avoir accès à plusieurs services.
Il doit pouvoir générer des justificatifs des différents papiers en sa possession (justificatifs de passeport, carte de séjour, carte d’identité, permis de conduire etc.) ainsi que des justificatifs des impôts qu’il auraient pu voir déjà versé ainsi qu’un justificatif des aides sociales qu’il aurait pu avoir perçu.
De plus il doit également être en mesure d’effectuer des démarches pour l’obtention de ces différents papiers et la régularisation de sa situation en faisant différentes déclarations lui permettant de payer ses impôts ou de percevoir des aides.
Ainsi le résident peut par exemple effectuer une déclaration de ses revenus qui devra être validé par un administrateur afin qu’il puisse payer les impôts correspondant a sa situation, de même pour les aides sociales.

### Administrateur {-}
L’administrateur a pour unique rôle de vérifier les déclarations faites par le résident.
Les déclarations concernant ses revenus pour les impôts et les déclarations qu’il auraient effectué pour percevoir certaines bourses ou autres aides sociales.

### Autorité {-}
Cette entité peut consulter les informations relatives aux habitants et compléter le casier judiciaire des habitants.
Hormis le casier judiciaire des habitant, il ne peut rien modifier mais il a un droit de regard sur toutes les informations concernant les utilisateurs enregistrés en tant que résidents.

## Liens et entités

### Papiers {-}

Un résident peut posséder déjà certains papiers, il peut en posséder plusieurs et en possède au moins un : sa carte d’identité.
De plus un papier ne peut appartenir qu’à une seule personne.
Un résident peut demander un ou plusieurs papiers et sa demande sera muni d’un formulaire.
D’où le lien « demander » entre l’entité « Résident » et l’entité « Papier » doublé d’un formulaire. Enfin lors de sa demande de papier ou lors ce qu’il consulte les papiers qu’il possède, un résident peut générer une preuve temporaire. Par exemple s’il demande une carte européenne d’assurance maladie il peut demander de générer un papier pouvant remplacer la carte pendant une certaine durée par exemple un mois. Une preuve temporaire ne peut correspondre qu’à un seul papier mais un résident peut demander plusieurs exemplaires de preuves temporaires de papiers.

### Impôts et aides sociales {-}

Un résident peut, tout d’abord, générer une preuve ou plusieurs preuves du payements passés de ses impôts, de plus il peut également faire une déclaration en remplissant un formulaire qui devrai être validé par un administrateur afin de pouvoir payer ses impôts.
Cela explique donc la relation ternaire entre l’entité « Impôt », l’entité « Résident » et l’entité « Administrateur » : Pour établir une déclaration afin de payer des impôts il faut qu’un Résident remplisse un ou plusieurs formulaires correspondant chacun a un impôt précis (par exemple impôt sur le revenu ), formulaires qui devront être validé par un Administrateur pour que la déclaration existe ;
Pour les aides sociales on retrouve exactement le même principe qu’avec les impôts pour comprendre cette partie il suffit donc se référer à l’explication ci-dessus

### Casier judiciaire {-}

Chaque résident possède un casier judiciaire (celui peut être vide ou non).
Il peut consulter son casier judiciaire mais ne peut le modifier.
Les autorités peuvent consulter le casier judiciaire de chaque habitant (comme toutes les autres informations) mais peuvent également le compléter ci besoin en renseignant de nouvelles informations ou en supprimant certaines.

## Schéma relationnel

### Entités

- Utilisateur(**identifiant**, motDePasse)
- Administrateur(**id**, nom, prenom, role)
- Authorite(**id**, nom, prenom, role, tribunal)
- Resident(**id**, nom, prenom, numSecu, dateNaissance, nationalite, codePostal)
- Papier(**id**, type, nom, dateDebut, dateFin)
- Impots(**id**, montant, date)
- AidesSociale(**id**, nom, montant, dateObtention, dateExpiration)
- ElementCasierJudiciaire(**id**, date, type, estApplique)

### Associations

#### Associations binaires {-}

- PossessionPapier(**idPapier**, idResident)
- DemandePapier(**idPapier**, idResident, formulaire)
- PreuveAideSociale(**idAide**, idResident, dateDocuemnt)
- PreuveImpots(**idImpots**, idResident, dateDocument)
- LienJudiciaire(**elementJudiciaire**, residentConcerne, authorite)

#### Associations ternaires {-}

- DeclarationImpots(**idImpots**, idResident, idAdministrateur)
- DemandeAideSociale(**idAide**, idResident, idAdministrateur)

### Dénormalisation

- La relation *Utilisateur* peut être supprimée en rajoutant ses attributs vers *Administrateur*, *Authorite* et *Resident*.
- La relation *PossessionPapier* peut être simplement inclus dans dans la relation *Papier*.
- On est tempté de supprimer les relations *PreuveAideSociale* et *PreuveImpots*, mais il est important de garder les numéros et dates de ces documents afin de pouvoir y revenir en cas de problèmes, et ce n'est pas cohérent d'avoir ses informations dans les relations *AideSociale* et *Impots* car ce ne sont que des justificatifs et le résident peut en prendre autant qu'il lui faut.

### Schéma relationnel final

- Administrateur(**id**, motDePasse, nom, prenom, role)
- Authorite(**id**, motDePasse, nom, prenom, role, tribunal)
- Resident(**id**, motDePasse, nom, prenom, numSecu, dateNaissance, nationalite, codePostal)
- Papier(**id**, idResident, type, nom, dateDebut, dateFin)
- Impots(**id**, montant, date)
- AidesSociale(**id**, nom, montant, dateObtention, dateExpiration)
- ElementCasierJudiciaire(**id**, date, type, estApplique)
- DemandePapier(**idPapier**, idResident, formulaire)
- PreuveAideSociale(**idAide**, idResident, dateDocument)
- PreuveImpots(**idImpots**, idResident, dateDocument)
- LienJudiciaire(**elementJudiciaire**, residentConcerne, authorite)
- DeclarationImpots(**idImpots**, idResident, idAdministrateur)
- DemandeAideSociale(**idAide**, idResident, idAdministrateur)