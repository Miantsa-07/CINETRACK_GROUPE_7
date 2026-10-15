-- =====================================================================
-- FICHIER : trigger_gestion_places.sql
-- Description : Fonctions et triggers pour la gestion automatique
--               des places restantes lors d'une réservation ou d'une annulation.
-- =====================================================================

-- 1. Fonction et Trigger : Mise à jour des places lors d'une réservation (INSERT)
CREATE OR REPLACE FUNCTION mettre_a_jour_places_restantes()
RETURNS TRIGGER AS $$
BEGIN
    -- Soustrait le nombre de places réservées des places restantes de la séance
UPDATE Seance
SET placesRestantes = placesRestantes - NEW.nombrePlaces
WHERE idSeance = NEW.idSeance;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maj_places_reservation
    AFTER INSERT ON Reservation
    FOR EACH ROW
    EXECUTE FUNCTION mettre_a_jour_places_restantes();


-- 2. Fonction et Trigger : Restitution des places lors d'une annulation (DELETE)
CREATE OR REPLACE FUNCTION restituer_places_restantes()
RETURNS TRIGGER AS $$
BEGIN
    -- Remet les places dans la séance lors de la suppression/annulation d'une réservation
UPDATE Seance
SET placesRestantes = placesRestantes + OLD.nombrePlaces
WHERE idSeance = OLD.idSeance;

RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_restituer_places_annulation
    AFTER DELETE ON Reservation
    FOR EACH ROW
    EXECUTE FUNCTION restituer_places_restantes();