SELECT SUM(montant) AS montant_total FROM Impot WHERE idResident=<idX>;
SELECT COUNT(id) FROM Resident INNER JOIN (AideSociale ON Resident.id=AideSociale.idResident) WHERE nationalite!=France;
SELECT SUM(montant)FROM AideSociale CROSS JOIN (Resident ON Resident.id=AideSociale.idResident) WHERE nationalite!=France;