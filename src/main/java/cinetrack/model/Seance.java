package cinetrack.model;

import java.time.LocalDateTime;

public class Seance {
    private int id;
    private LocalDateTime dateHeureDebut;
    private LocalDateTime dateHeureFin;
    private int placesRestantes;
    private Film film;
    private Salle salle;

    public Seance() { }
    public Seance(int id, LocalDateTime debut, LocalDateTime fin, int placesRestantes, Film film, Salle salle) {
        this.id = id; this.dateHeureDebut = debut; this.dateHeureFin = fin;
        this.placesRestantes = placesRestantes; this.film = film; this.salle = salle;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public LocalDateTime getDateHeureDebut() { return dateHeureDebut; }
    public void setDateHeureDebut(LocalDateTime d) { this.dateHeureDebut = d; }
    public LocalDateTime getDateHeureFin() { return dateHeureFin; }
    public void setDateHeureFin(LocalDateTime d) { this.dateHeureFin = d; }
    public int getPlacesRestantes() { return placesRestantes; }
    public void setPlacesRestantes(int p) { this.placesRestantes = p; }
    public Film getFilm() { return film; }
    public void setFilm(Film film) { this.film = film; }
    public Salle getSalle() { return salle; }
    public void setSalle(Salle salle) { this.salle = salle; }
}