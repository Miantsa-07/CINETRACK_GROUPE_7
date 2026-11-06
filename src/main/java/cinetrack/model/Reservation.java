package cinetrack.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Reservation {
    private Integer idReservation;
    private LocalDateTime dateReservation;
    private Integer nombrePlaces;
    private BigDecimal montantTotal;
    private Integer idClient;
    private Integer idSeance;
    private Integer idTarif;

    // Getters et Setters (Alt+Insert pour les générer si besoin)
    public Integer getIdReservation() { return idReservation; }
    public void setIdReservation(Integer idReservation) { this.idReservation = idReservation; }
    public LocalDateTime getDateReservation() { return dateReservation; }
    public void setDateReservation(LocalDateTime dateReservation) { this.dateReservation = dateReservation; }
    public Integer getNombrePlaces() { return nombrePlaces; }
    public void setNombrePlaces(Integer nombrePlaces) { this.nombrePlaces = nombrePlaces; }
    public BigDecimal getMontantTotal() { return montantTotal; }
    public void setMontantTotal(BigDecimal montantTotal) { this.montantTotal = montantTotal; }
    public Integer getIdClient() { return idClient; }
    public void setIdClient(Integer idClient) { this.idClient = idClient; }
    public Integer getIdSeance() { return idSeance; }
    public void setIdSeance(Integer idSeance) { this.idSeance = idSeance; }
    public Integer getIdTarif() { return idTarif; }
    public void setIdTarif(Integer idTarif) { this.idTarif = idTarif; }
}