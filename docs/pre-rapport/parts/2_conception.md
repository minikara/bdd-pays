# Modèle Entité/Association

## Description

Après plusieurs discussion nous avons réussi a poser les bases de notre modèle avec les différentes utilisations possible.
Le but de cette partie et de décrire précisément les différentes opérations possibles par les différents acteurs de la plateforme.

## Utilisateurs

3 utilisateurs différents pourraient utiliser la base de données : Le résident, un administrateur (chargé de vérifié les différentes déclaration des résidents afin de vérifier leur véridicité) et un représentant de l’autorité pouvant consulter les données relative à chaque habitant.

## Résident
Le résident doit tout d’abord pouvoir s’authentifier puis avoir accès à plusieurs services.
Il doit tout d’abord pouvoir générer des justificatifs des différents papiers en sa possession (justificatifs de passeport, carte de séjour, carte d’identité, permis de conduire etc.) ainsi que des justificatifs des impôts qu’il auraient pu voir déjà versé ainsi qu’un justificatifs des aides sociales qu’il aurait pu avoir perçu.
De plus il doit également être en mesure d’effectuer des démarches pour l’obtention de ces différents papier et la régularisation de sa situation en faisant différentes déclaration lui permettant de payer ses impôts ou de percevoir des aides.
Ainsi le résident peut par exemple effectuer une déclaration de ses revenus qui devra être validé par un administrateurs afin qu’il puisse payer les impôt correspondant a sa situation, de même pour les aides sociales.

## Administrateur
L’administrateur a pour unique rôle de vérifier les déclaration faites par le résident.
Les déclaration concernant ses revenus pour les impôts et les déclarations qu’il auraient effectuer pour percevoir certaines bourses ou autres aides sociales.

## Autorité
Cette entité peut consulter les information relatives aux habitants et compléter le casier judiciaire des habitants.
Hormis le casier judiciaire des habitant, il ne peut rien modifier mais il a un droit de regards sur toutes les informations concernant les utilisateurs enregistrés en tant qu’habitant.

## Liens et entités

## Papiers

Un habitant peut posséder déjà certains papiers, il peut en posséder plusieurs et en possède au moins un : sa carte d’identité. De plus un papier ne peut appartenir qu’a une seule personne. Un Résident peut demander un ou plusieurs papier et sa demande sera muni d’un formulaire.
D’où le lien « demander » entre l’entité « Résident » et l’entité « Papier » doublé d’un formulaire. Enfin lors de sa demande de papier ou lors ce qu’il consulte les papiers qu’il possède, un résident peut générer une preuve temporaire. Par exemple s’il demande une carte européenne d’assurance maladie il peut demander de générer un papier pouvant remplacer la carte pendant une certaine durée par exemple un mois. Une preuve temporaire ne peut corresponde qu’a un seule papier mais un habitant peut demander plusieurs exemplaires de preuves temporaires de papiers.

## Impôts et Aides Sociales

Un résident peut, tout d’abord, générer une preuve ou plusieurs preuve du payement passé de ses impôts, de plus il peut également faire une déclaration en remplissant un formulaire qui devrai être validé par un administrateur afin de pouvoir payer ses impôt.
Cela explique donc la relation ternaire entre l’entité « Impôt », l’entité « Résident » et l’entité « Administrateur » : Pour établir une déclaration afin de payer des impôts il faut qu’un Résident remplisse un ou plusieurs formulaires correspondant chacun a un impôt précis (par exemple impôt sur le revenu ), formulaires qui devront être validé par un Administrateur pour que la déclaration existe ;
Pour les aides sociales on retrouve exactement le même principe qu’avec les impôts pour comprendre cette partie il suffit donc se référer à l’explication ci-dessus

## Casier judiciaire

Chaque résident possède un casier judiciaire (celui peut être vide ou non).
Il peut consulter son casier judiciaire mais ne peut le modifier. Les autorités peuvent consulter le casier judiciaire de chaque habitant (comme toutes les autres informations) mais peuvent également le compléter ci besoin en renseignant de nouvelles informations ou en supprimant certaines.
