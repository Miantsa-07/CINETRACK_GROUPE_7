package cinetrack.main;

import cinetrack.dao.ReservationDAO;
import cinetrack.model.Reservation;

public class Main {
    public static void main(String[] args) {
        System.out.println("=== 🎬 CineTrack - Système de Billetterie ===");

        // 1. Créer une nouvelle réservation
        // Exemple : 2 places pour le client 1, séance 5, tarif 1 (Plein tarif)
        Reservation nouvelleResa = new Reservation();
        nouvelleResa.setIdClient(1);
        nouvelleResa.setIdSeance(5);
        nouvelleResa.setIdTarif(1);
        nouvelleResa.setNombrePlaces(2);

        // 2. On appelle le DAO pour sauvegarder en base
        ReservationDAO dao = new ReservationDAO();

        System.out.println("⏳ Tentative de réservation...");
        boolean succes = dao.creerReservation(nouvelleResa);

        if (succes) {
            System.out.println("✅ Réservation enregistrée avec succès !");
        } else {
            System.out.println("❌ Échec de la réservation.");
        }

        // 3. Afficher l'historique du client 1
        System.out.println("\n--- 📋 Historique du client 1 ---");
        dao.getReservationsParClient(1).forEach(r ->
                System.out.println("Résa n°" + r.getIdReservation() +
                        " | Places: " + r.getNombrePlaces() +
                        " | Total: " + r.getMontantTotal() + "€")
        );
    }
}