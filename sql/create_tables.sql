-- =====================================================================
-- Script de création des tables pour CINETRACK (PostgreSQL)
-- =====================================================================

-- 1. Table Utilisateur (Personnel du cinéma)
CREATE TABLE Utilisateur (
                             idUtilisateur SERIAL PRIMARY KEY,
                             identifiant VARCHAR(50) NOT NULL UNIQUE,
                             motDePasse VARCHAR(255) NOT NULL, -- Stocké haché (BCrypt)
                             role VARCHAR(30) NOT NULL       -- Ex: 'Administrateur', 'Caissier'
);

-- 2. Table Film
CREATE TABLE Film (
                      idFilm SERIAL PRIMARY KEY,
                      titre VARCHAR(150) NOT NULL,
                      duree INT NOT NULL,             -- En minutes
                      genre VARCHAR(50),
                      synopsis TEXT,
                      noteMoyenne NUMERIC(3,2) DEFAULT 0.00
);

-- 3. Table Salle
CREATE TABLE Salle (
                       idSalle SERIAL PRIMARY KEY,
                       nom VARCHAR(50) NOT NULL,
                       capacite INT NOT NULL
);

-- 4. Table Tarif (Catégories tarifaires)
CREATE TABLE Tarif (
                       idTarif SERIAL PRIMARY KEY,
                       libelle VARCHAR(50) NOT NULL,   -- Ex: 'Plein tarif', 'Étudiant', etc.
                       prixUnitaire NUMERIC(6,2) NOT NULL
);

-- 5. Table Client
CREATE TABLE Client (
                        idClient SERIAL PRIMARY KEY,
                        nom VARCHAR(50) NOT NULL,
                        prenom VARCHAR(50) NOT NULL,
                        coordonnees VARCHAR(255)        -- Téléphone ou email
);

-- 6. Table Séance (Dépend de Film et Salle)
CREATE TABLE Seance (
                        idSeance SERIAL PRIMARY KEY,
                        dateHeureDebut TIMESTAMP NOT NULL,
                        dateHeureFin TIMESTAMP NOT NULL,
                        placesRestantes INT NOT NULL,
                        idFilm INT NOT NULL,
                        idSalle INT NOT NULL,
                        CONSTRAINT fk_seance_film FOREIGN KEY (idFilm) REFERENCES Film(idFilm) ON DELETE CASCADE,
                        CONSTRAINT fk_seance_salle FOREIGN KEY (idSalle) REFERENCES Salle(idSalle) ON DELETE CASCADE
);

-- 7. Table Réservation (Dépend de Séance, Client et Tarif)
CREATE TABLE Reservation (
                             idReservation SERIAL PRIMARY KEY,
                             dateReservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             nombrePlaces INT NOT NULL,
                             montantTotal NUMERIC(8,2) NOT NULL,
                             idSeance INT NOT NULL,
                             idClient INT NOT NULL,
                             idTarif INT NOT NULL,
                             CONSTRAINT fk_reservation_seance FOREIGN KEY (idSeance) REFERENCES Seance(idSeance) ON DELETE CASCADE,
                             CONSTRAINT fk_reservation_client FOREIGN KEY (idClient) REFERENCES Client(idClient) ON DELETE CASCADE,
                             CONSTRAINT fk_reservation_tarif FOREIGN KEY (idTarif) REFERENCES Tarif(idTarif)
);

-- 8. Table Avis (Dépend de Client et Film)
CREATE TABLE Avis (
                      idAvis SERIAL PRIMARY KEY,
                      note INT CHECK (note >= 1 AND note <= 5),
                      commentaire TEXT,
                      dateAvis TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      idClient INT NOT NULL,
                      idFilm INT NOT NULL,
                      CONSTRAINT fk_avis_client FOREIGN KEY (idClient) REFERENCES Client(idClient) ON DELETE CASCADE,
                      CONSTRAINT fk_avis_film FOREIGN KEY (idFilm) REFERENCES Film(idFilm) ON DELETE CASCADE
);

-- 9. Table Log (Pour la traçabilité et la sécurité - CC4)
CREATE TABLE Log (
                     idLog SERIAL PRIMARY KEY,
                     identifiantUtilisateur VARCHAR(50),
                     action VARCHAR(255) NOT NULL,
                     dateHeure TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                     donneesConcernees TEXT
);