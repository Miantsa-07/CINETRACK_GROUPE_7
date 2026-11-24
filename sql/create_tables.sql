
CREATE TABLE Utilisateur (
                             idUtilisateur SERIAL PRIMARY KEY,
                             motDePasse VARCHAR(255) NOT NULL,
                             role VARCHAR(30) NOT NULL,
                             nom VARCHAR(50) NOT NULL,
                             prenom VARCHAR(50) NOT NULL,
                             contact VARCHAR(20),
                             mail VARCHAR(150)
);


CREATE TABLE Film (
                      idFilm SERIAL PRIMARY KEY,
                      titre VARCHAR(150) NOT NULL,
                      duree INT NOT NULL,
                      genre VARCHAR(50),
                      synopsis TEXT,
                      is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
                      date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      date_suppression TIMESTAMP
);


CREATE TABLE Salle (
                       idSalle SERIAL PRIMARY KEY,
                       nom VARCHAR(50) NOT NULL,
                       capacite INT NOT NULL,
                       nombre_colonne INT NOT NULL,
                       nombre_ligne INT NOT NULL
);

-- 4. Table Place (Dépend de Salle)
CREATE TABLE Place (
                       idPlace SERIAL PRIMARY KEY,
                       codePlace VARCHAR(10) NOT NULL,    -- Ex: 'A1', 'B5'
                       idSalle INT NOT NULL,
                       disponibilite BOOLEAN NOT NULL DEFAULT TRUE,
                       CONSTRAINT fk_place_salle FOREIGN KEY (idSalle) REFERENCES Salle(idSalle) ON DELETE CASCADE
);

-- 5. Table Tarif (Catégories tarifaires)
CREATE TABLE Tarif (
                       idTarif SERIAL PRIMARY KEY,
                       libelle VARCHAR(50) NOT NULL,      -- Ex: 'Plein tarif', 'Étudiant', etc.
                       prixUnitaire NUMERIC(6,2) NOT NULL
);

-- 6. Table Client
CREATE TABLE Client (
                        idClient SERIAL PRIMARY KEY,
                        nom VARCHAR(50) NOT NULL,
                        prenom VARCHAR(50) NOT NULL,
                        telephone VARCHAR(20),
                        email VARCHAR(150),
                        is_deleted BOOLEAN NOT NULL DEFAULT FALSE,   -- TRUE = "ancien client"
                        date_suppression TIMESTAMP                   -- Date de passage en ancien client
);

-- 7. Table Séance (Dépend de Film et Salle)
CREATE TABLE Seance (
                        idSeance SERIAL PRIMARY KEY,
                        dateHeureDebut TIMESTAMP NOT NULL,
                        dateHeureFin TIMESTAMP NOT NULL,
                        placesRestantes INT NOT NULL,
                        is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
                        date_suppression TIMESTAMP,
                        idFilm INT NOT NULL,
                        idSalle INT NOT NULL,
                        CONSTRAINT fk_seance_film FOREIGN KEY (idFilm) REFERENCES Film(idFilm) ON DELETE CASCADE,
                        CONSTRAINT fk_seance_salle FOREIGN KEY (idSalle) REFERENCES Salle(idSalle) ON DELETE CASCADE
);

-- 8. Table Action (Référentiel des actions)
CREATE TABLE Action (
                        idAction SERIAL PRIMARY KEY,
                        nomAction VARCHAR(100) NOT NULL UNIQUE  -- Ex: 'CREATION_FILM', 'SUPPRESSION_CLIENT'
);

-- 9. Table Réservation (Dépend de Séance, Client, Tarif et Place)
CREATE TABLE Reservation (
                             idReservation SERIAL PRIMARY KEY,
                             dateReservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             nombrePlaces INT NOT NULL,
                             is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
                             date_suppression TIMESTAMP,
                             idSeance INT NOT NULL,
                             idClient INT NOT NULL,
                             idTarif INT NOT NULL,
                             idPlace INT NOT NULL,
                             CONSTRAINT fk_reservation_seance FOREIGN KEY (idSeance) REFERENCES Seance(idSeance) ON DELETE CASCADE,
                             CONSTRAINT fk_reservation_client FOREIGN KEY (idClient) REFERENCES Client(idClient) ON DELETE CASCADE,
                             CONSTRAINT fk_reservation_tarif FOREIGN KEY (idTarif) REFERENCES Tarif(idTarif),
                             CONSTRAINT fk_reservation_place FOREIGN KEY (idPlace) REFERENCES Place(idPlace)
);

-- 10. Table Avis (Dépend de Client et Film)
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

-- 11. Table Log (Pour la traçabilité et la sécurité - CC4)
CREATE TABLE Log (
                     idLog SERIAL PRIMARY KEY,
                     identifiantUtilisateur VARCHAR(50),
                     action VARCHAR(255) NOT NULL,
                     dateHeure TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                     donneesConcernees TEXT,
                     idAction INT NOT NULL,
                     CONSTRAINT fk_log_action FOREIGN KEY (idAction) REFERENCES Action(idAction)
);

-- =====================================================================
-- Données initiales pour la table Action (exemple)
-- =====================================================================
INSERT INTO Action (nomAction) VALUES
                                   ('CONNEXION'),
                                   ('DECONNEXION'),
                                   ('INSERTION'),
                                   ('UPDATE'),
                                   ('DELETE');
