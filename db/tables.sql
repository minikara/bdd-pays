DROP DATABASE IF EXISTS pays;
CREATE DATABASE pays;
USE pays;

/* MAIN TABLES */

CREATE TABLE Resident (
  id INTEGER NOT NULL AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL,
  mdp VARCHAR(50) NOT NULL,
  nom VARCHAR(70) NOT NULL,
  prenom VARCHAR(35) NOT NULL,
  numSecu BIGINT(15),
  dateNaissance DATE NOT NULL,
  nationalite VARCHAR(90),
  codePostal VARCHAR(18),
  PRIMARY KEY (id)
);

CREATE TABLE Administrateur (
  id INTEGER NOT NULL AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL,
  mdp VARCHAR(50) NOT NULL,
  nom VARCHAR(70) NOT NULL,
  prenom VARCHAR(35) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE Autorite (
  id INTEGER NOT NULL AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL,
  mdp VARCHAR(50) NOT NULL,
  nom VARCHAR(70) NOT NULL,
  prenom VARCHAR(35) NOT NULL,
  tribunal VARCHAR(10),
  PRIMARY KEY (id)
);

CREATE TABLE Papier (
  id INTEGER NOT NULL AUTO_INCREMENT,
  typePapier VARCHAR(50),
  dateDebut DATE,
  dateFin DATE,
  etat VARCHAR(20),
  tarif INTEGER,
  idResident INTEGER NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (idResident) REFERENCES Resident(id)
);

CREATE TABLE AideSociale (
  id INTEGER NOT NULL AUTO_INCREMENT,
  typeAide VARCHAR(70) NOT NULL,
  frequence VARCHAR(10),
  montant INT,
  dateObtention DATE,
  dateExpiration DATE,
  etat VARCHAR(20),
  idResident INTEGER NOT NULL,
  idAdmin INTEGER,
  PRIMARY KEY (id),
  FOREIGN KEY (idResident) REFERENCES Resident(id),
  FOREIGN KEY (idAdmin) REFERENCES Administrateur(id)
);

CREATE TABLE Impots (
  id INTEGER NOT NULL AUTO_INCREMENT,
  montant INT,
  dateDeclaration DATE,
  etat VARCHAR(20),
  idResident INTEGER NOT NULL,
  idAdmin INTEGER,
  PRIMARY KEY (id),
  FOREIGN KEY (idResident) REFERENCES Resident(id),
  FOREIGN KEY (idAdmin) REFERENCES Administrateur(id)
);

CREATE TABLE ElementJudiciaire (
  id INTEGER NOT NULL AUTO_INCREMENT,
  dateElement DATE,
  typeElement VARCHAR(10),
  peine VARCHAR(10),
  idResident INTEGER NOT NULL,
  idAuthorite INTEGER NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (idResident) REFERENCES Resident(id),
  FOREIGN KEY (idAuthorite) REFERENCES Autorite(id)
);


/* JUNCTION TABLES

CREATE TABLE DeclarationImports (
  idImpots INTEGER NOT NULL,
  idResident INTEGER NOT NULL,
  idAdmin INTEGER NOT NULL,
  PRIMARY KEY (idImpots, idResident),
  FOREIGN KEY (idImpots) REFERENCES Impots(id),
  FOREIGN KEY (idResident) REFERENCES Resident(id),
  FOREIGN KEY (idAdmin) REFERENCES Administrateur(id)
);

CREATE TABLE DemandeAideSociale (
  idAide INTEGER NOT NULL,
  idResident INTEGER NOT NULL,
  idAdmin INTEGER NOT NULL,
  PRIMARY KEY (idAide, idResident),
  FOREIGN KEY (idAide) REFERENCES AideSociale(id),
  FOREIGN KEY (idResident) REFERENCES Resident(id),
  FOREIGN KEY (idAdmin) REFERENCES Administrateur(id)
);

*/
