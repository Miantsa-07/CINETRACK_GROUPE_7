-- =====================================================================
-- FICHIER : trigger_log_tarif.sql
-- Description : Fonction et trigger pour consigner les modifications
--               et suppressions de tarifs dans la table Log (CC4).
-- =====================================================================

-- 1. Fonction PL/pgSQL pour les logs de la table Tarif
CREATE OR REPLACE FUNCTION f_log_action_tarif()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        INSERT INTO Log (identifiantUtilisateur, action, dateHeure, donneesConcernees)
        VALUES (
            CURRENT_USER,
            'MODIFICATION_TARIF',
            CURRENT_TIMESTAMP,
            CONCAT('Modification du tarif ID: ', NEW.idTarif, ' - Ancien libellé: ', OLD.libelle, ' (', OLD.prixUnitaire, '€) -> Nouveau: ', NEW.libelle, ' (', NEW.prixUnitaire, '€)')
        );
RETURN NEW;

ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO Log (identifiantUtilisateur, action, dateHeure, donneesConcernees)
        VALUES (
            CURRENT_USER,
            'SUPPRESSION_TARIF',
            CURRENT_TIMESTAMP,
            CONCAT('Suppression du tarif ID: ', OLD.idTarif, ' (', OLD.libelle, ')')
        );
RETURN OLD;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 2. Création du déclencheur (Trigger) associé à la table Tarif
CREATE TRIGGER trg_log_tarif
    AFTER UPDATE OR DELETE ON Tarif
FOR EACH ROW
EXECUTE FUNCTION f_log_action_tarif();