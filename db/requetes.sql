/*
Combien de non français profite des aides sociaux
Combien d'argent est donné au non français en aides sociaux (par an par exemple)
Combien a un individu X payé n impots (toute sa vie)
Lister tout les admins dans l'ordre de nombre de tâches dont ils sont chargé
*/


SELECT SUM(montant) AS montant_total
FROM Impots
WHERE idResident=1;

SELECT COUNT(DISTINCT(Resident.id))
FROM Resident
INNER JOIN AideSociale ON Resident.id = AideSociale.idResident
WHERE nationalite <> 'France' AND etat = 'Valide';

/* ancienne version

SELECT typeAide, frequence, montant, CASE frequence
    WHEN 'a' THEN montant * (YEAR(LEAST(CURDATE(), dateExpiration)) - YEAR(dateObtention))
    WHEN 'm' THEN montant * FLOOR((DATEDIFF(LEAST(CURDATE(), dateExpiration), dateObtention)) / 31)
    ELSE montant END AS montantTotal, etat, dateObtention, dateExpiration, idResident, nationalite
FROM AideSociale
INNER JOIN Resident on AideSociale.idResident = Resident.id; */

SELECT id, typeAide, frequence, montant,
    CASE frequence
        WHEN 'a' THEN montant * (timestampdiff(year, dateObtention, dateExpiration))
        WHEN 'm' THEN montant * (timestampdiff(month, dateObtention, dateExpiration))
        ELSE montant
    END AS montantTotal,
    etat,
    dateObtention,
    dateExpiration,
    idResident
FROM AideSociale;


CREATE VIEW AideTotale AS
SELECT id
    CASE frequence
        WHEN 'a' THEN montant * (timestampdiff(year, dateObtention, dateExpiration))
        WHEN 'm' THEN montant * (timestampdiff(month, dateObtention, dateExpiration))
        ELSE montant
    END AS montantTotal
FROM AideSociale;

/* requete en 3 parties

SELECT SUM(montant) as montant_p
FROM aidesociale
WHERE frequence ='p'

SELECT SUM(ABS(TIMESTAMPDIFF(month, dateObtention,dateExpiration))*montant) as montant_m
FROM aidesociale
WHERE frequence = 'm'

SELECT SUM(ABS(TIMESTAMPDIFF(year, dateObtention,dateExpiration))*montant) as montant_a
FROM aidesociale
WHERE frequence = 'a' */

/*
SELECT SUM(montant)
FROM ( SELECT id, SUM(montant) as montant
		FROM AideSociale
		WHERE frequence ='p'
      	UNION ALL SELECT id, SUM(ABS(TIMESTAMPDIFF(month, dateObtention,dateExpiration))*montant) as montant
		FROM AideSociale
		WHERE frequence = 'm'
       	UNION ALL SELECT id, SUM(ABS(TIMESTAMPDIFF(year, dateObtention,dateExpiration))*montant) as montant
		FROM AideSociale
		WHERE frequence = 'a'
     ) as total;
*/


/*
SELECT id, email, nom, prenom, nbTaches from Administrateur LEFT JOIN (
    SELECT COUNT(ALL id) AS nbTaches, idAdmin FROM (
        SELECT id, idAdmin FROM AideSociale WHERE etat = "EnCoursDeValidation"
        UNION ALL SELECT id, idAdmin FROM Impots WHERE etat = "EnCoursDeValidation"
    ) AS tUnion
    GROUP BY idAdmin
) AS tCount ON tCount.idAdmin = Administrateur.id
ORDER BY nbTaches;

SELECT id, email, nom, prenom, tache from Administrateur LEFT OUTER JOIN (
       SELECT id as tache, idAdmin FROM AideSociale WHERE etat = "EnCoursDeValidation"
       UNION ALL SELECT id as tache, idAdmin FROM Impots WHERE etat = "EnCoursDeValidation"
) AS t ON t.idAdmin = Administrateur.id;

SELECT Administrateur.id, email, nom, prenom, COUNT(ALL t.id) from Administrateur
LEFT OUTER JOIN (
    SELECT id, idAdmin FROM AideSociale WHERE etat="EnCoursDeValidation"
) AS t ON t.idAdmin = Administrateur.id
GROUP BY t.idAdmin;
 */