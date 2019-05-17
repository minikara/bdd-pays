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

SELECT * FROM Impots, AideSociale
WHERE etat = 'EnCoursDeValidation';


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

SELECT SUM(montant)
FROM ( SELECT id, SUM(montant) as montant
		FROM aidesociale
		WHERE frequence ='p'
      	UNION ALL SELECT id, SUM(ABS(TIMESTAMPDIFF(month, dateObtention,dateExpiration))*montant) as montant
		FROM aidesociale 
		WHERE frequence = 'm'
       	UNION ALL SELECT id, SUM(ABS(TIMESTAMPDIFF(year, dateObtention,dateExpiration))*montant) as montant
		FROM aidesociale
		WHERE frequence = 'a'
     ) as total