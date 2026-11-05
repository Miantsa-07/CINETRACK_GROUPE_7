package cinetrack.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tarif")
public class Tarif {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idTarif;

    private String libelle;
    private BigDecimal prixUnitaire;

    // Getters et Setters
    public Integer getIdTarif() { return idTarif; }
    public void setIdTarif(Integer idTarif) { this.idTarif = idTarif; }
    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }
    public BigDecimal getPrixUnitaire() { return prixUnitaire; }
    public void setPrixUnitaire(BigDecimal prixUnitaire) { this.prixUnitaire = prixUnitaire; }
}