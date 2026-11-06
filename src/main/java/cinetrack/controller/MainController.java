package cinetrack.controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.StackPane;

import java.io.IOException;

public class MainController {

    @FXML private StackPane contentPane;
    @FXML private Label lblUtilisateur;

    @FXML private Button btnReservations;
    @FXML private Button btnPlanning;
    @FXML private Button btnFilms;
    @FXML private Button btnSalles;
    @FXML private Button btnClients;
    @FXML private Button btnStats;
    @FXML private Button btnUtilisateurs;
    @FXML private Button btnLogs;
    @FXML private Button btnInventaire;
    @FXML private Button btnDeconnexion;

    /** Appelée après la connexion pour afficher l'utilisateur. */
    public void setUtilisateur(String nom, String role) {
        lblUtilisateur.setText(nom + " (" + role + ")");
        // Droits : seul l'administrateur voit ces sections
        boolean admin = "ADMIN".equalsIgnoreCase(role);
        btnUtilisateurs.setVisible(admin);
        btnUtilisateurs.setManaged(admin);
        btnLogs.setVisible(admin);
        btnLogs.setManaged(admin);
    }

    // ===== Navigation =====
    @FXML private void onReservations() { charger("ReservationView.fxml", btnReservations); }
    @FXML private void onPlanning()     { charger("PlanningView.fxml", btnPlanning); }
    @FXML private void onFilms()        { charger("FilmView.fxml", btnFilms); }
    @FXML private void onSalles()       { charger("SalleView.fxml", btnSalles); }
    @FXML private void onClients()      { charger("ClientView.fxml", btnClients); }
    @FXML private void onStats()        { charger("StatsView.fxml", btnStats); }
    @FXML private void onUtilisateurs() { charger("UtilisateurView.fxml", btnUtilisateurs); }
    @FXML private void onLogs()         { charger("LogsView.fxml", btnLogs); }
    @FXML private void onInventaire()   { charger("InventaireView.fxml", btnInventaire); }

    @FXML
    private void onDeconnexion() {
        // À compléter : fermer cette fenêtre et rouvrir LoginView
    }

    /** Charge une vue dans la zone centrale et surligne le bouton actif. */
    private void charger(String fichierFxml, Button boutonActif) {
        try {
            Node vue = FXMLLoader.load(getClass().getResource("/view/" + fichierFxml));
            contentPane.getChildren().setAll(vue);
            surligner(boutonActif);
        } catch (IOException | NullPointerException e) {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setTitle("Erreur");
            alert.setHeaderText("Impossible d'ouvrir la vue");
            alert.setContentText(fichierFxml + " est introuvable ou invalide.");
            alert.showAndWait();
        }
    }

    private void surligner(Button boutonActif) {
        Button[] boutons = {btnReservations, btnPlanning, btnFilms, btnSalles, btnClients,
                btnStats, btnUtilisateurs, btnLogs, btnInventaire};
        for (Button b : boutons) {
            b.getStyleClass().remove("menu-btn-active");
        }
        boutonActif.getStyleClass().add("menu-btn-active");
    }
}