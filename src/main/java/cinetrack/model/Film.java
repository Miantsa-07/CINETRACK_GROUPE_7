package cinetrack.model;

import java.util.Objects;

public class Film {

    private int id;
    private String titre;
    private String genre;
    private int duree;            // en minutes
    private String synopsis;
    private Double noteMoyenne;   // calculée à partir des avis, null s'il n'y en a pas

    public Film() {
    }

    /** Constructeur pour un nouveau film (pas encore d'id, la base le génère). */
    public Film(String titre, String genre, int duree, String synopsis) {
        this.titre = titre;
        this.genre = genre;
        this.duree = duree;
        this.synopsis = synopsis;
    }

    /** Constructeur pour un film lu depuis la base. */
    public Film(int id, String titre, String genre, int duree, String synopsis, Double noteMoyenne) {
        this(titre, genre, duree, synopsis);
        this.id = id;
        this.noteMoyenne = noteMoyenne;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }

    public int getDuree() { return duree; }
    public void setDuree(int duree) { this.duree = duree; }

    public String getSynopsis() { return synopsis; }
    public void setSynopsis(String synopsis) { this.synopsis = synopsis; }

    public Double getNoteMoyenne() { return noteMoyenne; }
    public void setNoteMoyenne(Double noteMoyenne) { this.noteMoyenne = noteMoyenne; }

    /** Utile pour afficher le titre dans les ComboBox (planning). */
    @Override
    public String toString() {
        return titre;
    }

    @Override public boolean equals(Object o) { return o instanceof Film f && f.id == id; }
    @Override public int hashCode() { return Objects.hash(id); }
}