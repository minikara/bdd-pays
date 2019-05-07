DROP DATABASE IF EXISTS pays;
CREATE DATABASE pays;
USE pays;

/* MAIN TABLES */

CREATE TABLE Resident (
  identifiant INTEGER NOT NULL AUTO_INCREMENT,
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
  identifiant INTEGER NOT NULL AUTO_INCREMENT,
  mdp VARCHAR(50) NOT NULL,
  nom VARCHAR(70) NOT NULL,
  prenom VARCHAR(35) NOT NULL,
  roleAdmin VARCHAR(10),
  PRIMARY KEY (identifiant)
);

CREATE TABLE AideSociale (
  id INTEGER NOT NULL AUTO_INCREMENT,
  nom VARCHAR(70) NOT NULL,
  montant INT,
  dateObtention DATE,
  dateExpiration DATE,
  PRIMARY KEY (id)
);

CREATE TABLE Impots (
  id INTEGER NOT NULL AUTO_INCREMENT,
  montant INT,
  dateDeclaration DATE,
  PRIMARY KEY (id)
);

CREATE TABLE Autorite (
  identifiant INTEGER NOT NULL AUTO_INCREMENT,
  mdp VARCHAR(50) NOT NULL,
  nom VARCHAR(70) NOT NULL,
  tribunal VARCHAR(10),
  roleAutorite VARCHAR(10),
  PRIMARY KEY (identifiant)
);

CREATE TABLE ElementCasierJudiciaire (
  id INTEGER NOT NULL AUTO_INCREMENT,
  dateElement DATE,
  typeElement VARCHAR(10),
  estApplique BOOLEAN,
  PRIMARY KEY (id)
);

CREATE TABLE Papier (
  id INTEGER NOT NULL AUTO_INCREMENT,
  typePapier VARCHAR(10),
  nom VARCHAR(70) NOT NULL,
  dateDebut DATE,
  dateFin DATE,
  PRIMARY KEY (id)
);

/* JUNCTION TABLES */