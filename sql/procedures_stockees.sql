CREATE OR REPLACE PROCEDURE sp_creer_reservation(
    p_id_seance       INT,
    p_id_client       INT,
    p_id_tarif        INT,
    p_id_place        INT,
    p_nombre_places   INT,
    OUT p_id_resa     INT,
    OUT p_montant     NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
DECLARE
v_places_dispo INT;
    v_prix_unit    NUMERIC(6,2);
    v_conflit      INT;
BEGIN
    IF p_nombre_places IS NULL OR p_nombre_places <= 0 THEN
        RAISE EXCEPTION 'Le nombre de places doit être supérieur à 0.';
END IF;

SELECT placesrestantes INTO v_places_dispo
FROM seance
WHERE idseance = p_id_seance AND is_deleted = FALSE;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Séance introuvable ou supprimée (idseance=%).', p_id_seance;
END IF;

    IF v_places_dispo < p_nombre_places THEN
        RAISE EXCEPTION 'Places insuffisantes (restantes : %, demandées : %).', v_places_dispo, p_nombre_places;
END IF;

    -- Vérifie si la place est déjà réservée (non annulée/supprimée) sur cette séance
SELECT COUNT(*) INTO v_conflit
FROM reservation
WHERE idseance = p_id_seance
  AND idplace = p_id_place
  AND is_deleted = FALSE;

IF v_conflit > 0 THEN
        RAISE EXCEPTION 'La place % est déjà réservée pour cette séance.', p_id_place;
END IF;

SELECT prixunitaire INTO v_prix_unit
FROM tarif
WHERE idtarif = p_id_tarif;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Tarif introuvable (idtarif=%).', p_id_tarif;
END IF;

    p_montant := v_prix_unit * p_nombre_places;

INSERT INTO reservation (nombreplaces, is_deleted, idseance, idclient, idtarif, idplace)
VALUES (p_nombre_places, FALSE, p_id_seance, p_id_client, p_id_tarif, p_id_place)
    RETURNING idreservation INTO p_id_resa;
END;
$$;