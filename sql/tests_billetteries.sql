-- ============================================================================
-- SCÉNARIO DE TEST : CRÉATION + ANNULATION + TRIGGER
-- ============================================================================

-- 1. Vérifier les places disponibles avant réservation (ex: séance 5)
SELECT idseance, placesrestantes FROM seance WHERE idseance = 5;

-- 2. Créer une réservation (décrémente automatiquement placesrestantes)
CALL sp_creer_reservation(5, 1, 1, 15, 1, NULL, NULL, NULL);

-- 3. Vérifier que placesrestantes a diminué de 1
SELECT idseance, placesrestantes FROM seance WHERE idseance = 5;

-- 4. Récupérer l'ID de la réservation créée
SELECT idreservation, idseance, idclient, idtarif, idplace, nombreplaces, is_deleted
FROM reservation
WHERE idseance = 5
ORDER BY idreservation DESC
    LIMIT 1;

-- 5. Annuler la réservation (remplacer 16 par l'ID affiché à l'étape 4)
CALL sp_annuler_reservation(16);

-- 6. Vérifier que placesrestantes est revenue à sa valeur initiale
SELECT idseance, placesrestantes FROM seance WHERE idseance = 5;