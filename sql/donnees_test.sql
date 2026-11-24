-- =====================================================================
-- DONNÉES DE TEST POUR CINETRACK
-- Adapté au script de création fourni (Utilisateur sans "identifiant",
-- Log avec identifiantUtilisateur VARCHAR)
-- =====================================================================

-- ----------------------------------------------------------------
-- 1. Utilisateurs (personnel du cinéma)
-- ----------------------------------------------------------------
-- ⚠️ La table Utilisateur n'a pas de colonne "identifiant" dans le
--    script de création. On insère uniquement les colonnes existantes.
-- Rappel des idUtilisateur générés :
--   1 = admin, 2 = directeur, 3 = caissier1, 4 = caissier2
-- ----------------------------------------------------------------
-- INSERT INTO Utilisateur (identifiant, motDePasse, role) VALUES
-- ('admin',            'admin123',   'Administrateur'),
-- ('caissier1',        'caisse1',    'Caissier'),
-- ('caissier2',        'caisse2',    'Caissier'),
-- ('projectionniste',  'proj2025',   'Projectionniste');

INSERT INTO Utilisateur (motDePasse, role, nom, prenom, contact, mail) VALUES
                                                                           ('$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Administrateur', 'Admin',   'Système', '0600000001', 'admin@cinetrack.fr'),
                                                                           ('$2a$10$7J0p/z9cK0KWlgHnDCEqvNeQfpvzFWjEpKAmoEpJiEpIuEpKAmoEp', 'Directeur',      'Durand',  'Marc',    '0600000002', 'directeur@cinetrack.fr'),
                                                                           ('$2a$10$8K1p/a0dL1LXMIgoEDFrwOfgqwAGXkFqLBnrFqKjFqJtFqLBnrFqK', 'Caissier',       'Martin',  'Julie',   '0600000003', 'caissier1@cinetrack.fr'),
                                                                           ('$2a$10$9L2q/b1eM2MYNJhpFEgswPghrxBHYlGraMcsGrLkGrKuGrMcsaMcs', 'Caissier',       'Bernard', 'Paul',    '0600000004', 'caissier2@cinetrack.fr');

-- ----------------------------------------------------------------
-- 2. Films
-- ----------------------------------------------------------------
INSERT INTO Film (titre, duree, genre, synopsis, is_deleted, date_creation) VALUES
                                                                                ('Inception',                            148, 'Science-Fiction',    'Un voleur d''idées infiltre les rêves pour y dérober des secrets.',             FALSE, '2025-01-01 09:00:00'),
                                                                                ('Le Fabuleux Destin d''Amélie Poulain', 122, 'Comédie',            'Une jeune serveuse parisienne décide de changer la vie des gens.',             FALSE, '2025-01-01 09:05:00'),
                                                                                ('Interstellar',                         169, 'Science-Fiction',    'Un groupe d''explorateurs voyage à travers un trou de ver.',                   FALSE, '2025-01-01 09:10:00'),
                                                                                ('Intouchables',                         112, 'Comédie dramatique', 'L''amitié improbable entre un aristocrate tétraplégique et son aide-soignant.', FALSE, '2025-01-01 09:15:00'),
                                                                                ('Parasite',                             132, 'Thriller',           'Une famille pauvre s''infiltre chez une famille riche.',                       FALSE, '2025-01-01 09:20:00'),
                                                                                ('Oppenheimer',                          180, 'Biopic',             'La vie du physicien J. Robert Oppenheimer.',                                   FALSE, '2025-01-01 09:25:00'),
                                                                                ('Dune: Deuxième Partie',                166, 'Science-Fiction',    'Paul Atréides s''allie aux Fremen pour se venger.',                            FALSE, '2025-01-01 09:30:00'),
                                                                                ('Top Gun: Maverick',                    131, 'Action',             'Maverick forme une nouvelle génération de pilotes.',                           FALSE, '2025-01-01 09:35:00'),
                                                                                ('Everything Everywhere All at Once',    139, 'Science-Fiction',    'Une femme découvre qu''elle doit sauver le multivers.',                        FALSE, '2025-01-01 09:40:00'),
                                                                                ('Le Discours d''un Roi',                118, 'Drame historique',   'Le roi George VI surmonte son bégaiement.',                                    FALSE, '2025-01-01 09:45:00');

-- Film "supprimé" (is_deleted = TRUE)
INSERT INTO Film (titre, duree, genre, synopsis, is_deleted, date_creation, date_suppression) VALUES
    ('Film Retiré de l''Affiche', 95, 'Drame', 'Film ancien retiré du catalogue.', TRUE, '2024-06-01 09:00:00', '2025-01-01 10:00:00');

-- ----------------------------------------------------------------
-- 3. Salles (3 salles, capacité max 80)
-- ----------------------------------------------------------------
INSERT INTO Salle (nom, capacite, nombre_colonne, nombre_ligne) VALUES
                                                                    ('Petite',  40,  8, 5),   -- 8 × 5 = 40 places
                                                                    ('Moyenne', 60, 10, 6),   -- 10 × 6 = 60 places
                                                                    ('Grande',  80, 10, 8);   -- 10 × 8 = 80 places

-- ----------------------------------------------------------------
-- 4. Places (générées automatiquement)
-- ----------------------------------------------------------------
-- Petite : codes A1..H5 (40 places)
INSERT INTO Place (codePlace, idSalle, disponibilite)
SELECT chr(64 + ligne) || colonne, 1, TRUE
FROM generate_series(1, 8) AS colonne,
     generate_series(1, 5) AS ligne;

-- Moyenne : codes A1..J6 (60 places)
INSERT INTO Place (codePlace, idSalle, disponibilite)
SELECT chr(64 + ligne) || colonne, 2, TRUE
FROM generate_series(1, 10) AS colonne,
     generate_series(1, 6) AS ligne;

-- Grande : codes A1..J8 (80 places)
INSERT INTO Place (codePlace, idSalle, disponibilite)
SELECT chr(64 + ligne) || colonne, 3, TRUE
FROM generate_series(1, 10) AS colonne,
     generate_series(1, 8) AS ligne;

-- ----------------------------------------------------------------
-- 5. Tarifs
-- ----------------------------------------------------------------
INSERT INTO Tarif (libelle, prixUnitaire) VALUES
                                              ('Plein tarif',              12.50),
                                              ('Tarif réduit',              9.50),
                                              ('Étudiant',                  7.50),
                                              ('Enfant (moins de 12 ans)',  6.00),
                                              ('Senior (65+)',              8.00),
                                              ('Carte abonné',              6.50),
                                              ('Tarif groupe (10+)',        8.50);

-- ----------------------------------------------------------------
-- 6. Clients
-- ----------------------------------------------------------------
INSERT INTO Client (nom, prenom, telephone, email, is_deleted) VALUES
                                                                   ('Dupont',   'Marie',  '0612345678', 'marie.dupont@email.com',   FALSE),
                                                                   ('Martin',   'Pierre', '0612345679', NULL,                       FALSE),
                                                                   ('Bernard',  'Sophie', NULL,         'sophie.bernard@email.com', FALSE),
                                                                   ('Petit',    'Lucas',  '0798765432', NULL,                       FALSE),
                                                                   ('Durand',   'Emma',   NULL,         'emma.durand@email.com',    FALSE),
                                                                   ('Leroy',    'Thomas', '0611223344', NULL,                       FALSE),
                                                                   ('Moreau',   'Chloé',  NULL,         'chloe.moreau@email.com',   FALSE),
                                                                   ('Simon',    'Hugo',   '0755667788', NULL,                       FALSE),
                                                                   ('Laurent',  'Léa',    NULL,         'lea.laurent@email.com',    FALSE),
                                                                   ('Lefebvre', 'Nathan', NULL,         NULL,                       FALSE);

-- Client "ancien" (is_deleted = TRUE)
INSERT INTO Client (nom, prenom, telephone, email, is_deleted, date_suppression) VALUES
    ('Ancien', 'Client', '0600000000', 'ancien.client@email.com', TRUE, '2025-06-01 12:00:00');

-- ----------------------------------------------------------------
-- 7. Séances
-- ----------------------------------------------------------------
INSERT INTO Seance (dateHeureDebut, dateHeureFin, placesRestantes, idFilm, idSalle, is_deleted) VALUES
-- Séances passées
('2025-01-10 14:00:00', '2025-01-10 16:28:00',  0,  1, 1, FALSE),  -- Inception, Petite (complète)
('2025-01-10 20:00:00', '2025-01-10 22:02:00', 60,  2, 2, FALSE),  -- Amélie, Moyenne
('2025-01-11 18:00:00', '2025-01-11 20:49:00', 40,  3, 3, FALSE),  -- Interstellar, Grande
('2025-01-12 16:00:00', '2025-01-12 17:52:00', 40,  4, 1, FALSE),  -- Intouchables, Petite
-- Séances futures
('2025-12-15 14:00:00', '2025-12-15 16:12:00', 40,  5, 1, FALSE),  -- Parasite, Petite
('2025-12-15 18:00:00', '2025-12-15 21:00:00', 80,  6, 3, FALSE),  -- Oppenheimer, Grande
('2025-12-16 20:30:00', '2025-12-16 23:16:00', 60,  7, 2, FALSE),  -- Dune 2, Moyenne
('2025-12-16 16:00:00', '2025-12-16 18:11:00', 40,  8, 1, FALSE),  -- Top Gun, Petite
('2025-12-17 19:00:00', '2025-12-17 21:19:00', 40,  9, 1, FALSE),  -- Everything..., Petite
('2025-12-17 21:00:00', '2025-12-17 22:58:00', 80, 10, 3, FALSE);  -- Le Discours, Grande

-- Séance "supprimée" (is_deleted = TRUE)
INSERT INTO Seance (dateHeureDebut, dateHeureFin, placesRestantes, idFilm, idSalle, is_deleted, date_suppression) VALUES
    ('2025-02-01 14:00:00', '2025-02-01 16:00:00', 40, 2, 1, TRUE, '2025-01-15 10:00:00');

-- ----------------------------------------------------------------
-- 8. Réservations (1 réservation = 1 place)
-- ----------------------------------------------------------------
INSERT INTO Reservation (dateReservation, nombrePlaces, is_deleted, idSeance, idClient, idTarif, idPlace) VALUES
-- Séance 1 (Inception, complète)
('2025-01-05 10:30:00', 1, FALSE, 1,  1, 1, (SELECT idPlace FROM Place WHERE idSalle=1 AND codePlace='A1')),
('2025-01-06 14:15:00', 1, FALSE, 1,  2, 3, (SELECT idPlace FROM Place WHERE idSalle=1 AND codePlace='A2')),
-- Séance 2 (Amélie)
('2025-01-08 09:00:00', 1, FALSE, 2,  3, 2, (SELECT idPlace FROM Place WHERE idSalle=2 AND codePlace='A1')),
('2025-01-09 19:45:00', 1, FALSE, 2,  4, 5, (SELECT idPlace FROM Place WHERE idSalle=2 AND codePlace='A2')),
-- Séance 5 (Parasite)
('2025-11-20 15:00:00', 1, FALSE, 5,  5, 1, (SELECT idPlace FROM Place WHERE idSalle=1 AND codePlace='B1')),
('2025-11-21 11:30:00', 1, FALSE, 5,  6, 2, (SELECT idPlace FROM Place WHERE idSalle=1 AND codePlace='B2')),
('2025-11-22 18:00:00', 1, FALSE, 5,  7, 7, (SELECT idPlace FROM Place WHERE idSalle=1 AND codePlace='B3')),
-- Séance 6 (Oppenheimer)
('2025-11-25 10:00:00', 1, FALSE, 6,  8, 1, (SELECT idPlace FROM Place WHERE idSalle=3 AND codePlace='A1')),
('2025-11-25 10:05:00', 1, FALSE, 6,  9, 3, (SELECT idPlace FROM Place WHERE idSalle=3 AND codePlace='A2')),
-- Séance 7 (Dune 2)
('2025-11-26 20:00:00', 1, FALSE, 7, 10, 6, (SELECT idPlace FROM Place WHERE idSalle=2 AND codePlace='C1'));

-- Réservation annulée (is_deleted = TRUE)
INSERT INTO Reservation (dateReservation, nombrePlaces, is_deleted, date_suppression, idSeance, idClient, idTarif, idPlace) VALUES
    ('2025-11-26 16:00:00', 1, TRUE, '2025-11-26 17:00:00', 8, 6, 2, (SELECT idPlace FROM Place WHERE idSalle=1 AND codePlace='C1'));

-- ----------------------------------------------------------------
-- 9. Avis
-- ----------------------------------------------------------------
INSERT INTO Avis (note, commentaire, dateAvis, idClient, idFilm) VALUES
                                                                     (5, 'Chef-d''œuvre absolu, à voir et revoir !',          '2025-01-11 20:00:00', 1,  1),
                                                                     (4, 'Très bon film, scénario intelligent.',              '2025-01-11 21:30:00', 2,  1),
                                                                     (5, 'Une pure merveille, poétique et touchante.',        '2025-01-12 10:00:00', 3,  2),
                                                                     (5, 'Bouleversant, porté par des acteurs formidables.',  '2025-01-13 09:15:00', 4,  4),
                                                                     (4, 'Excellent thriller, tension palpable.',             '2025-01-14 14:00:00', 5,  5),
                                                                     (3, 'Bon film mais un peu long.',                        '2025-11-23 10:00:00', 6,  5),
                                                                     (4, 'Très immersif, visuellement époustouflant.',        '2025-11-26 22:00:00', 7,  7),
                                                                     (5, 'Une claque cinématographique.',                     '2025-11-27 08:30:00', 8,  6),
                                                                     (2, 'Déçu, je m''attendais à mieux.',                    '2025-11-28 19:00:00', 9,  8),
                                                                     (3, 'Sympa sans plus.',                                  '2025-11-29 12:00:00', 10, 9);

-- ----------------------------------------------------------------
-- 10. Logs (identifiantUtilisateur = VARCHAR, comme dans le script de création)
-- ----------------------------------------------------------------
INSERT INTO Log (identifiantUtilisateur, action, dateHeure, donneesConcernees, idAction) VALUES
                                                                                             ('admin',      'INSERTION_FILM',          '2025-11-01 09:00:00', 'Film id=1 "Inception"',             (SELECT idAction FROM Action WHERE nomAction='INSERTION')),
                                                                                             ('admin',      'INSERTION_SEANCE',        '2025-11-02 10:30:00', 'Séance id=5 (Parasite)',            (SELECT idAction FROM Action WHERE nomAction='INSERTION')),
                                                                                             ('caissier1',  'INSERTION_RESERVATION',   '2025-11-20 15:00:00', 'Réservation id=5, client id=5',     (SELECT idAction FROM Action WHERE nomAction='INSERTION')),
                                                                                             ('caissier2',  'INSERTION_RESERVATION',   '2025-11-25 10:00:00', 'Réservation id=8, client id=8',     (SELECT idAction FROM Action WHERE nomAction='INSERTION')),
                                                                                             ('admin',      'UPDATE_TARIF',            '2025-11-25 14:00:00', 'Tarif id=1 : 12.00 → 12.50',        (SELECT idAction FROM Action WHERE nomAction='UPDATE')),
                                                                                             ('admin',      'UPDATE_FILM',             '2025-11-26 09:00:00', 'Film id=2 : synopsis modifié',      (SELECT idAction FROM Action WHERE nomAction='UPDATE')),
                                                                                             ('caissier1',  'DELETE_RESERVATION',      '2025-11-26 16:00:00', 'Réservation id=10 (annulée)',       (SELECT idAction FROM Action WHERE nomAction='DELETE')),
                                                                                             ('admin',      'DELETE_FILM',             '2025-11-27 11:00:00', 'Film id=11 (retiré de l''affiche)', (SELECT idAction FROM Action WHERE nomAction='DELETE')),
                                                                                             ('admin',      'INSERTION_UTILISATEUR',   '2025-11-27 14:00:00', 'Utilisateur id=2 (directeur)',      (SELECT idAction FROM Action WHERE nomAction='INSERTION')),
                                                                                             ('admin',      'CONNEXION',               '2025-11-27 08:00:00', 'IP=192.168.1.10',                   (SELECT idAction FROM Action WHERE nomAction='CONNEXION')),
                                                                                             ('directeur',  'CONNEXION',               '2025-11-28 09:00:00', 'IP=192.168.1.20',                   (SELECT idAction FROM Action WHERE nomAction='CONNEXION')),
                                                                                             ('caissier2',  'DECONNEXION',             '2025-11-28 17:30:00', 'Session fermée',                    (SELECT idAction FROM Action WHERE nomAction='DECONNEXION'));

-- ----------------------------------------------------------------
-- 11. Synchronisation de placesRestantes
-- ----------------------------------------------------------------
UPDATE Seance s
SET placesRestantes = sa.capacite - COALESCE((
                                                 SELECT SUM(r.nombrePlaces)
                                                 FROM Reservation r
                                                 WHERE r.idSeance = s.idSeance
                                                   AND r.is_deleted = FALSE
                                             ), 0)
    FROM Salle sa
WHERE s.idSalle = sa.idSalle;

-- ----------------------------------------------------------------
-- 12. Mise à jour de la disponibilité des places
-- ----------------------------------------------------------------
UPDATE Place p
SET disponibilite = FALSE
WHERE p.idPlace IN (
    SELECT r.idPlace
    FROM Reservation r
    WHERE r.is_deleted = FALSE
);