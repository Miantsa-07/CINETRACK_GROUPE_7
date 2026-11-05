package cinetrack.controller;

import cinetrack.exception.CineTrackException;
import cinetrack.exception.ValidationException;
import cinetrack.model.Salle;
import cinetrack.service.SalleService;
import cinetrack.util.Session;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;

public class SalleController {

    @FXML private TableView<Salle> tblSalles;
    @FXML private TableColumn<Salle, String> colNom;
    @FXML private TableColumn<Salle, Integer> colCapacite;
    @FXML private TextField txtNom;
    @FXML private TextField txtCapacite;
    @FXML private Label lblMessage;
    @FXML private Button btnAjouter;
    @FXML private Button btnModifier;
    @FXML private Button btnSupprimer;

    private final SalleService salleService = new SalleService();
    private final ObservableList<Salle> salles = FXCollections.observableArrayList();

    @FXML
    public void initialize() {
        colNom.setCellValueFactory(new PropertyValueFactory<>("nom"));
        colCapacite.setCellValueFactory(new PropertyValueFactory<>("capacite"));
        tblSalles.setItems(salles);

        tblSalles.getSelectionModel().selectedItemProperty().addListener((obs, ancien, salle) -> {
            if (salle != null) {
                txtNom.setText(salle.getNom());
                txtCapacite.setText(String.valueOf(salle.getCapacite()));
                lblMessage.setText("");
            }
        });

        boolean admin = Session.estAdmin();
        btnSupprimer.setVisible(admin);
        btnSupprimer.setManaged(admin);

        recharger();
    }

    @FXML
    private void onAjouter() {
        try {
            salleService.ajouter(lireFormulaire());
            viderFormulaire();
            recharger();
            afficherSucces("Salle ajoutée.");
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    @FXML
    private void onModifier() {
        Salle selection = tblSalles.getSelectionModel().getSelectedItem();
        if (selection == null) {
            afficherErreur("Sélectionnez une salle dans le tableau.");
            return;
        }
        try {
            Salle salle = lireFormulaire();
            salle.setId(selection.getId());
            salleService.modifier(salle);
            viderFormulaire();
            recharger();
            afficherSucces("Salle modifiée.");
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    @FXML
    private void onSupprimer() {
        Salle selection = tblSalles.getSelectionModel().getSelectedItem();
        if (selection == null) {
            afficherErreur("Sélectionnez une salle dans le tableau.");
            return;
        }
        Alert confirmation = new Alert(Alert.AlertType.CONFIRMATION,
                "Supprimer la salle « " + selection.getNom() + " » ?", ButtonType.YES, ButtonType.NO);
        confirmation.setHeaderText(null);
        if (confirmation.showAndWait().orElse(ButtonType.NO) != ButtonType.YES) {
            return;
        }
        try {
            salleService.supprimer(selection.getId());
            viderFormulaire();
            recharger();
            afficherSucces("Salle supprimée.");
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    // ===== Outils =====

    private void recharger() {
        try {
            salles.setAll(salleService.lister());
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    private Salle lireFormulaire() {
        String texte = txtCapacite.getText() == null ? "" : txtCapacite.getText().trim();
        int capacite;
        try {
            capacite = Integer.parseInt(texte);
        } catch (NumberFormatException e) {
            throw new ValidationException("La capacité doit être un nombre entier.");
        }
        return new Salle(txtNom.getText(), capacite);
    }

    private void viderFormulaire() {
        txtNom.clear();
        txtCapacite.clear();
        tblSalles.getSelectionModel().clearSelection();
    }

    private void afficherErreur(String message) {
        lblMessage.setStyle("-fx-text-fill: #dc2626;");
        lblMessage.setText(message);
    }

    private void afficherSucces(String message) {
        lblMessage.setStyle("-fx-text-fill: #16a34a;");
        lblMessage.setText(message);
    }
}