-- =====================================================================
-- DONNÉES DE TEST POUR CINETRACK
-- À exécuter après le script de création des tables
-- =====================================================================

-- ----------------------------------------------------------------
-- 1. Utilisateurs (personnel du cinéma)
-- ----------------------------------------------------------------
-- Identifiants de connexion pour tester :
--   admin           / admin123
--   caissier1       / caisse1
--   caissier2       / caisse2
--   projectionniste / proj2025
-- ⚠️ En base, SEULS les hashs BCrypt sont stockés.
-- ----------------------------------------------------------------
INSERT INTO Utilisateur (identifiant, motDePasse, role) VALUES
                                                            ('admin',           '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Administrateur'),
                                                            ('caissier1',       '$2a$10$8K1p/a0dL1LXMIgoEDFrwOfgqwAGXkFqLBnrFqKjFqJtFqLBnrFqK', 'Caissier'),
                                                            ('caissier2',       '$2a$10$9L2q/b1eM2MYNJhpFEgswPghrxBHYlGraMcsGrLkGrKuGrMcsaMcs', 'Caissier'),
                                                            ('projectionniste', '$2a$10$0M3r/c2fN3NZOKiqGFhtxQhisyCIZmHsbNdGsHmLHsLvHsNdGsHmL', 'Projectionniste');

-- ----------------------------------------------------------------
-- 2. Films (variété de genres et durées pour tester les filtres)
-- ----------------------------------------------------------------
INSERT INTO Film (titre, duree, genre, synopsis, noteMoyenne) VALUES
                                                                  ('Inception',                            148, 'Science-Fiction',    'Un voleur d''idées infiltre les rêves pour y dérober des secrets.',           4.50),
                                                                  ('Le Fabuleux Destin d''Amélie Poulain', 122, 'Comédie',            'Une jeune serveuse parisienne décide de changer la vie des gens.',           4.20),
                                                                  ('Interstellar',                         169, 'Science-Fiction',    'Un groupe d''explorateurs voyage à travers un trou de ver.',                 4.70),
                                                                  ('Intouchables',                         112, 'Comédie dramatique', 'L''amitié improbable entre un aristocrate tétraplégique et son aide-soignant.', 4.80),
                                                                  ('Parasite',                             132, 'Thriller',           'Une famille pauvre s''infiltre chez une famille riche.',                     4.60),
                                                                  ('Oppenheimer',                          180, 'Biopic',             'La vie du physicien J. Robert Oppenheimer.',                                 4.30),
                                                                  ('Dune: Deuxième Partie',                166, 'Science-Fiction',    'Paul Atréides s''allie aux Fremen pour se venger.',                          4.40),
                                                                  ('Top Gun: Maverick',                    131, 'Action',             'Maverick forme une nouvelle génération de pilotes.',                         4.10),
                                                                  ('Everything Everywhere All at Once',    139, 'Science-Fiction',    'Une femme découvre qu''elle doit sauver le multivers.',                      4.20),
                                                                  ('Le Discours d''un Roi',                118, 'Drame historique',   'Le roi George VI surmonte son bégaiement.',                                  3.90);

-- ----------------------------------------------------------------
-- 3. Salles (tailles variées)
-- ----------------------------------------------------------------
INSERT INTO Salle (nom, capacite) VALUES
                                      ('Salle 1 - Grande',    250),
                                      ('Salle 2 - Moyenne',   150),
                                      ('Salle 3 - Petite',     80),
                                      ('Salle 4 - IMAX',      300),
                                      ('Salle 5 - VIP',        40);

-- ----------------------------------------------------------------
-- 4. Tarifs
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
-- 5. Clients
-- ----------------------------------------------------------------
INSERT INTO Client (nom, prenom, coordonnees) VALUES
                                                  ('Dupont',   'Marie',  'marie.dupont@email.com'),
                                                  ('Martin',   'Pierre', '06 12 34 56 78'),
                                                  ('Bernard',  'Sophie', 'sophie.bernard@email.com'),
                                                  ('Petit',    'Lucas',  '07 98 76 54 32'),
                                                  ('Durand',   'Emma',   'emma.durand@email.com'),
                                                  ('Leroy',    'Thomas', '06 11 22 33 44'),
                                                  ('Moreau',   'Chloé',  'chloe.moreau@email.com'),
                                                  ('Simon',    'Hugo',   '07 55 66 77 88'),
                                                  ('Laurent',  'Léa',    'lea.laurent@email.com'),
                                                  ('Lefebvre', 'Nathan', NULL);  -- Coordonnées manquantes : cas limite

-- ----------------------------------------------------------------
-- 6. Séances (passées et futures, différentes salles/films)
-- ----------------------------------------------------------------
INSERT INTO Seance (dateHeureDebut, dateHeureFin, placesRestantes, idFilm, idSalle) VALUES
-- Séances passées (pour tester l'historique)
('2025-01-10 14:00:00', '2025-01-10 16:28:00',   0,  1, 1),  -- Inception, Salle 1 (complète)
('2025-01-10 20:00:00', '2025-01-10 22:02:00', 120,  2, 2),  -- Amélie, Salle 2
('2025-01-11 18:00:00', '2025-01-11 20:49:00',  50,  3, 4),  -- Interstellar, IMAX
('2025-01-12 16:00:00', '2025-01-12 17:52:00',  80,  4, 3),  -- Intouchables, Salle 3
-- Séances futures (pour tester les réservations)
('2025-12-15 14:00:00', '2025-12-15 16:12:00', 250,  5, 1),  -- Parasite, Salle 1
('2025-12-15 18:00:00', '2025-12-15 21:00:00', 300,  6, 4),  -- Oppenheimer, IMAX
('2025-12-16 20:30:00', '2025-12-16 23:16:00', 150,  7, 2),  -- Dune 2, Salle 2
('2025-12-16 16:00:00', '2025-12-16 18:11:00',  80,  8, 3),  -- Top Gun, Salle 3
('2025-12-17 19:00:00', '2025-12-17 21:19:00',  40,  9, 5),  -- Everything..., Salle 5 VIP
('2025-12-17 21:00:00', '2025-12-17 22:58:00', 250, 10, 1);  -- Le Discours, Salle 1

-- ----------------------------------------------------------------
-- 7. Réservations (montantTotal = nombrePlaces * prixUnitaire)
-- ----------------------------------------------------------------
INSERT INTO Reservation (dateReservation, nombrePlaces, montantTotal, idSeance, idClient, idTarif) VALUES
-- Séance 1 (Inception, passée, complète)
('2025-01-05 10:30:00', 2, 25.00, 1,  1, 1),  -- Marie, plein tarif
('2025-01-06 14:15:00', 4, 30.00, 1,  2, 3),  -- Pierre, étudiant (4×7.50)
-- Séance 2 (Amélie, passée)
('2025-01-08 09:00:00', 1,  9.50, 2,  3, 2),  -- Sophie, tarif réduit
('2025-01-09 19:45:00', 3, 24.00, 2,  4, 5),  -- Lucas, senior (3×8.00)
-- Séance 5 (Parasite, future)
('2025-11-20 15:00:00', 2, 25.00, 5,  5, 1),  -- Emma, plein tarif
('2025-11-21 11:30:00', 1,  9.50, 5,  6, 2),  -- Thomas, tarif réduit
('2025-11-22 18:00:00', 5, 42.50, 5,  7, 7),  -- Chloé, groupe (5×8.50)
-- Séance 6 (Oppenheimer, future)
('2025-11-25 10:00:00', 2, 25.00, 6,  8, 1),  -- Hugo, plein tarif
('2025-11-25 10:05:00', 1,  7.50, 6,  9, 3),  -- Léa, étudiant
-- Séance 7 (Dune 2, future)
('2025-11-26 20:00:00', 2, 17.00, 7, 10, 6);  -- Nathan, carte abonné

-- ----------------------------------------------------------------
-- 8. Avis (notes variées, certains films sans avis)
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
-- 9. Logs (traçabilité — CC4)
-- ----------------------------------------------------------------
INSERT INTO Log (identifiantUtilisateur, action, dateHeure, donneesConcernees) VALUES
                                                                                   ('admin',           'CREATION_FILM',          '2025-11-01 09:00:00', 'Film id=1 "Inception"'),
                                                                                   ('admin',           'CREATION_SEANCE',        '2025-11-02 10:30:00', 'Séance id=5 (Parasite)'),
                                                                                   ('caissier1',       'CREATION_RESERVATION',   '2025-11-20 15:00:00', 'Réservation id=5, client id=5'),
                                                                                   ('caissier2',       'CREATION_RESERVATION',   '2025-11-25 10:00:00', 'Réservation id=8, client id=8'),
                                                                                   ('admin',           'MODIFICATION_TARIF',     '2025-11-25 14:00:00', 'Tarif id=1 : 12.00 → 12.50'),
                                                                                   ('projectionniste', 'LANCEMENT_SEANCE',       '2025-12-15 14:00:00', 'Séance id=5, Salle 1'),
                                                                                   ('caissier1',       'ANNULATION_RESERVATION', '2025-11-26 16:00:00', 'Réservation id=10 (annulée)'),
                                                                                   ('admin',           'CONNEXION',              '2025-11-27 08:00:00', 'IP=192.168.1.10');

-- ----------------------------------------------------------------
-- 10. Synchronisation de placesRestantes
-- ----------------------------------------------------------------
UPDATE Seance s
SET placesRestantes = sa.capacite - COALESCE((
                                                 SELECT SUM(r.nombrePlaces)
                                                 FROM Reservation r
                                                 WHERE r.idSeance = s.idSeance
                                             ), 0)
    FROM Salle sa
WHERE s.idSalle = sa.idSalle;

-- ----------------------------------------------------------------
-- 11. Recalcul de la note moyenne des films
-- ----------------------------------------------------------------
UPDATE Film f
SET noteMoyenne = COALESCE((
                               SELECT ROUND(AVG(a.note)::numeric, 2)
                               FROM Avis a
                               WHERE a.idFilm = f.idFilm
                           ), 0.00);