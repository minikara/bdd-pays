SELECT SUM(montant) AS montant_total
FROM Impots
WHERE idResident=1;

SELECT COUNT(DISTINCT(Resident.id))
FROM Resident
INNER JOIN AideSociale ON Resident.id = AideSociale.idResident
WHERE nationalite <> 'France' AND etat = 'Valide';

SELECT typeAide, frequence, montant, CASE frequence
    WHEN 'a' THEN montant * (YEAR(LEAST(CURDATE(), dateExpiration)) - YEAR(dateObtention))
    WHEN 'm' THEN montant * FLOOR((DATEDIFF(LEAST(CURDATE(), dateExpiration), dateObtention)) / 31)
    ELSE montant END AS montantTotal, etat, dateObtention, dateExpiration, idResident, nationalite
FROM AideSociale
INNER JOIN Resident on AideSociale.idResident = Resident.id;

SELECT * FROM Impots, AideSociale
WHERE etat = 'EnCoursDeValidation';
