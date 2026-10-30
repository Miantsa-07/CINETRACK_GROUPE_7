package cinetrack.dao.interfaces;

import cinetrack.model.Film;

import java.util.List;
import java.util.Optional;

public interface FilmDAO {

    void ajouter(Film film);

    void modifier(Film film);

    void supprimer(int id);

    Optional<Film> trouverParId(int id);

    List<Film> trouverTous();

    /** Recherche par titre (partiel) et/ou genre. Un critère null est ignoré. */
    List<Film> rechercher(String titre, String genre);
}