DROP DATABASE IF EXISTS pays;
CREATE DATABASE pays;
USE pays;

/* MAIN TABLES */

CREATE TABLE Resident (
  identifiant VARCHAR(50) NOT NULL,
  mdp VARCHAR(50) NOT NULL,
  nom VARCHAR(70) NOT NULL,
  prenom VARCHAR(35) NOT NULL,
  numSecu INT(15),
  dateNaissance DATE,
  nationalite CHAR(3),
  codePostal int(5) NOT NULL,
  PRIMARY KEY (identifiant)
);

CREATE TABLE Administrateur (
  identifiant VARCHAR(50) NOT NULL,
  mdp VARCHAR(50) NOT NULL,
  nom VARCHAR(70) NOT NULL,
  prenom VARCHAR(35) NOT NULL,
  roleAdmin VARCHAR(10),
  PRIMARY KEY (identifiant)
);

CREATE TABLE Autorite (
  identifiant VARCHAR(50) NOT NULL,
  mdp VARCHAR(50) NOT NULL,
  nom VARCHAR(70) NOT NULL,
  tribunal VARCHAR(10),
  roleAutorite VARCHAR(10),
  PRIMARY KEY (identifiant)
);

CREATE TABLE Papier (
  id INTEGER NOT NULL AUTO_INCREMENT,
  typePapier VARCHAR(10),
  nom VARCHAR(70) NOT NULL,
  dateDebut DATE,
  dateFin DATE,
  etat VARCHAR(10),
  idResident VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (idResident) REFERENCES Resident(identifiant)
);

CREATE TABLE AideSociale (
  id INTEGER NOT NULL AUTO_INCREMENT,
  nom VARCHAR(70) NOT NULL,
  montant INT,
  dateObtention DATE,
  dateExpiration DATE,
  etat VARCHAR(10),
  idResident VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (idResident) REFERENCES Resident(identifiant)
);

CREATE TABLE Impots (
  id INTEGER NOT NULL AUTO_INCREMENT,
  montant INT,
  dateDeclaration DATE,
  etat VARCHAR(10),
  idResident VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (idResident) REFERENCES Resident(identifiant)
);

CREATE TABLE ElementJudiciaire (
  id INTEGER NOT NULL AUTO_INCREMENT,
  dateElement DATE,
  typeElement VARCHAR(10),
  peine VARCHAR(10),
  idResident VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (idResident) REFERENCES Resident(identifiant)
);


/* JUNCTION TABLES */

CREATE TABLE DeclarationImports (
  idImpots INTEGER NOT NULL,
  idResident VARCHAR(50) NOT NULL,
  idAdmin VARCHAR(50) NOT NULL,
  PRIMARY KEY (idImpots, idResident),
  FOREIGN KEY (idImpots) REFERENCES Impots(id),
  FOREIGN KEY (idResident) REFERENCES Resident(identifiant),
  FOREIGN KEY (idAdmin) REFERENCES Administrateur(identifiant)
);

CREATE TABLE DemandeAideSociale (
  idAide INTEGER NOT NULL,
  idResident VARCHAR(50) NOT NULL,
  idAdmin VARCHAR(50) NOT NULL,
  PRIMARY KEY (idAide, idResident),
  FOREIGN KEY (idAide) REFERENCES AideSociale(id),
  FOREIGN KEY (idResident) REFERENCES Resident(identifiant),
  FOREIGN KEY (idAdmin) REFERENCES Administrateur(identifiant)
);
