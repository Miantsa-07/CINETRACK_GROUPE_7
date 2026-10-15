-- Fonction qui insère une ligne dans la table Log lors d'une suppression de réservation
CREATE OR REPLACE FUNCTION log_suppression_reservation()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO Log (identifiantUtilisateur, action, dateHeure, donneesConcernees)
VALUES (
                   CURRENT_USER, -- Ou l'identifiant de l'application connecté
                   'ANNULATION_RESERVATION',
                   CURRENT_TIMESTAMP,
                   CONCAT('Suppression de la reservation ID: ', OLD.idReservation, ' pour la seance ID: ', OLD.idSeance, ' (', OLD.nombrePlaces, ' places)')
       );
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Association du trigger à la table Reservation
CREATE TRIGGER trg_log_annulation_reservation
    AFTER DELETE ON Reservation
    FOR EACH ROW
    EXECUTE FUNCTION log_suppression_reservation();