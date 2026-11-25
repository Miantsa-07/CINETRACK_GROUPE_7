-- ============================================================================
-- CINETRACK - PROCÉDURES STOCKÉES & TRIGGER (BILLETTERIE / RÉSERVATIONS)
-- ============================================================================

-- 1. Procédure de création d'une réservation
CREATE OR REPLACE PROCEDURE sp_creer_reservation(
    p_id_seance     INT,
    p_id_client     INT,
    p_id_tarif      INT,
    p_id_place      INT,
    p_nombre_places INT,
    OUT p_id_resa   INT,
    OUT p_montant   NUMERIC(10,2),
    OUT p_code_billet VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE
v_places_dispo INT;
    v_prix_unit    NUMERIC(6,2);
BEGIN
    -- Vérification des places disponibles sur la séance active
SELECT placesrestantes INTO v_places_dispo
FROM seance
WHERE idseance = p_id_seance AND is_deleted = FALSE;

IF v_places_dispo IS NULL OR v_places_dispo < p_nombre_places THEN
        RAISE EXCEPTION 'Pas assez de places disponibles pour cette séance.';
END IF;

    -- Récupération du tarif unitaire et calcul du montant
SELECT prixunitaire INTO v_prix_unit
FROM tarif
WHERE idtarif = p_id_tarif;

p_montant := v_prix_unit * p_nombre_places;

    -- Génération d'un code billet unique
    p_code_billet := 'BILLET-' || p_id_seance || '-' || p_id_place || '-' || FLOOR(RANDOM() * 9000 + 1000)::INT;

    -- Insertion de la réservation
INSERT INTO reservation (nombreplaces, is_deleted, idseance, idclient, idtarif, idplace)
VALUES (p_nombre_places, FALSE, p_id_seance, p_id_client, p_id_tarif, p_id_place)
    RETURNING idreservation INTO p_id_resa;
END;
$$;


-- 2. Procédure d'annulation logique d'une réservation
CREATE OR REPLACE PROCEDURE sp_annuler_reservation(
    p_id_resa INT
)
LANGUAGE plpgsql
AS $$
BEGIN
UPDATE reservation
SET is_deleted = TRUE,
    date_suppression = CURRENT_TIMESTAMP
WHERE idreservation = p_id_resa
  AND is_deleted = FALSE;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Réservation introuvable ou déjà annulée (idreservation=%).', p_id_resa;
END IF;
END;
$$;


-- 3. Fonction trigger de mise à jour automatique des places restantes
CREATE OR REPLACE FUNCTION fn_maj_places_seance()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Création d'une réservation : on décrémente les places restantes
    IF TG_OP = 'INSERT' AND NEW.is_deleted = FALSE THEN
UPDATE seance
SET placesrestantes = placesrestantes - NEW.nombreplaces
WHERE idseance = NEW.idseance;

-- Annulation d'une réservation : on réincrémente les places restantes
ELSIF TG_OP = 'UPDATE' AND OLD.is_deleted = FALSE AND NEW.is_deleted = TRUE THEN
UPDATE seance
SET placesrestantes = placesrestantes + OLD.nombreplaces
WHERE idseance = NEW.idseance;
END IF;

RETURN NEW;
END;
$$;


-- 4. Déclencheur associé à la table reservation
DROP TRIGGER IF EXISTS trg_maj_places_reservation ON reservation;

CREATE TRIGGER trg_maj_places_reservation
    AFTER INSERT OR UPDATE OF is_deleted ON reservation
    FOR EACH ROW
    EXECUTE FUNCTION fn_maj_places_seance();