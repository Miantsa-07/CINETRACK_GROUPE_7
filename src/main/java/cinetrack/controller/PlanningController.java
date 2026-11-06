package cinetrack.controller;

import cinetrack.exception.CineTrackException;
import cinetrack.exception.ValidationException;
import cinetrack.model.Film;
import cinetrack.model.Salle;
import cinetrack.model.Seance;
import cinetrack.service.FilmService;
import cinetrack.service.SalleService;
import cinetrack.service.SeanceService;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class PlanningController {

    private static final DateTimeFormatter FORMAT_DATE = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter FORMAT_HEURE = DateTimeFormatter.ofPattern("HH:mm");

    // Filtres
    @FXML private DatePicker dpFiltreDate;
    @FXML private ComboBox<Salle> cbFiltreSalle;
    @FXML private ComboBox<Film> cbFiltreFilm;
    // Tableau
    @FXML private TableView<Seance> tblSeances;
    @FXML private TableColumn<Seance, String> colFilm;
    @FXML private TableColumn<Seance, String> colSalle;
    @FXML private TableColumn<Seance, String> colDate;
    @FXML private TableColumn<Seance, String> colDebut;
    @FXML private TableColumn<Seance, String> colFin;
    @FXML private TableColumn<Seance, String> colPlaces;
    // Formulaire
    @FXML private ComboBox<Film> cbFilm;
    @FXML private ComboBox<Salle> cbSalle;
    @FXML private DatePicker dpDate;
    @FXML private TextField txtHeureDebut;
    @FXML private Label lblHeureFin;
    @FXML private Label lblMessage;

    private final SeanceService seanceService = new SeanceService();
    private final FilmService filmService = new FilmService();
    private final SalleService salleService = new SalleService();
    private final ObservableList<Seance> seances = FXCollections.observableArrayList();

    private boolean ignorerFiltres = false;   // évite de recharger plusieurs fois lors d'une réinitialisation

    @FXML
    public void initialize() {
        // Colonnes
        colFilm.setCellValueFactory(cd -> new SimpleStringProperty(cd.getValue().getFilm().getTitre()));
        colSalle.setCellValueFactory(cd -> new SimpleStringProperty(cd.getValue().getSalle().getNom()));
        colDate.setCellValueFactory(cd -> new SimpleStringProperty(cd.getValue().getDateHeureDebut().format(FORMAT_DATE)));
        colDebut.setCellValueFactory(cd -> new SimpleStringProperty(cd.getValue().getDateHeureDebut().format(FORMAT_HEURE)));
        colFin.setCellValueFactory(cd -> new SimpleStringProperty(cd.getValue().getDateHeureFin().format(FORMAT_HEURE)));
        colPlaces.setCellValueFactory(cd -> new SimpleStringProperty(String.valueOf(cd.getValue().getPlacesRestantes())));
        tblSeances.setItems(seances);

        // Listes déroulantes (chargées depuis les services)
        try {
            ObservableList<Film> listeFilms = FXCollections.observableArrayList(filmService.lister());
            ObservableList<Salle> listeSalles = FXCollections.observableArrayList(salleService.lister());
            cbFilm.setItems(listeFilms);
            cbFiltreFilm.setItems(listeFilms);
            cbSalle.setItems(listeSalles);
            cbFiltreSalle.setItems(listeSalles);
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
        afficherTexteVide(cbFiltreFilm, "Tous les films");
        afficherTexteVide(cbFiltreSalle, "Toutes les salles");

        // Clic sur une ligne : remplit le formulaire
        tblSeances.getSelectionModel().selectedItemProperty().addListener((obs, ancien, s) -> {
            if (s != null) {
                cbFilm.setValue(s.getFilm());
                cbSalle.setValue(s.getSalle());
                dpDate.setValue(s.getDateHeureDebut().toLocalDate());
                txtHeureDebut.setText(s.getDateHeureDebut().format(FORMAT_HEURE));
                lblMessage.setText("");
            }
        });

        // Calcul automatique de l'heure de fin
        cbFilm.valueProperty().addListener((obs, a, b) -> majHeureFin());
        dpDate.valueProperty().addListener((obs, a, b) -> majHeureFin());
        txtHeureDebut.textProperty().addListener((obs, a, b) -> majHeureFin());

        onFiltrer();
    }

    // ===== Filtres =====

    @FXML
    private void onFiltrer() {
        if (ignorerFiltres) {
            return;
        }
        try {
            seances.setAll(seanceService.filtrer(
                    dpFiltreDate.getValue(), cbFiltreSalle.getValue(), cbFiltreFilm.getValue()));
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    @FXML
    private void onReinitFiltres() {
        ignorerFiltres = true;
        dpFiltreDate.setValue(null);
        cbFiltreSalle.setValue(null);
        cbFiltreFilm.setValue(null);
        ignorerFiltres = false;
        onFiltrer();
    }

    // ===== Actions =====

    @FXML
    private void onAjouter() {
        try {
            verifierChoix();
            seanceService.ajouter(cbFilm.getValue(), cbSalle.getValue(), lireDebut());
            viderFormulaire();
            onFiltrer();
            afficherSucces("Séance programmée.");
        } catch (CineTrackException e) {   // inclut ConflitSeanceException : message explicite du service
            afficherErreur(e.getMessage());
        }
    }

    @FXML
    private void onModifier() {
        Seance selection = tblSeances.getSelectionModel().getSelectedItem();
        if (selection == null) {
            afficherErreur("Sélectionnez une séance dans le tableau.");
            return;
        }
        try {
            verifierChoix();
            seanceService.modifier(selection.getId(), cbFilm.getValue(), cbSalle.getValue(), lireDebut());
            viderFormulaire();
            onFiltrer();
            afficherSucces("Séance modifiée.");
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    @FXML
    private void onSupprimer() {
        Seance selection = tblSeances.getSelectionModel().getSelectedItem();
        if (selection == null) {
            afficherErreur("Sélectionnez une séance dans le tableau.");
            return;
        }
        Alert confirmation = new Alert(Alert.AlertType.CONFIRMATION,
                "Supprimer la séance de « " + selection.getFilm().getTitre() + " » ?", ButtonType.YES, ButtonType.NO);
        confirmation.setHeaderText(null);
        if (confirmation.showAndWait().orElse(ButtonType.NO) != ButtonType.YES) {
            return;
        }
        try {
            seanceService.supprimer(selection.getId());
            viderFormulaire();
            onFiltrer();
            afficherSucces("Séance supprimée.");
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    // ===== Outils =====

    private void verifierChoix() {
        if (cbFilm.getValue() == null) {
            throw new ValidationException("Veuillez choisir un film.");
        }
        if (cbSalle.getValue() == null) {
            throw new ValidationException("Veuillez choisir une salle.");
        }
    }

    /** Combine la date et l'heure saisies en un LocalDateTime. */
    private LocalDateTime lireDebut() {
        if (dpDate.getValue() == null) {
            throw new ValidationException("Veuillez choisir une date.");
        }
        try {
            LocalTime heure = LocalTime.parse(txtHeureDebut.getText().trim(), FORMAT_HEURE);
            return dpDate.getValue().atTime(heure);
        } catch (DateTimeParseException | NullPointerException e) {
            throw new ValidationException("L'heure doit être au format HH:mm (ex : 18:30).");
        }
    }

    /** Affiche l'heure de fin prévue (début + durée du film). */
    private void majHeureFin() {
        try {
            if (cbFilm.getValue() == null || dpDate.getValue() == null) {
                lblHeureFin.setText("Fin prévue : --:--");
                return;
            }
            LocalDateTime fin = lireDebut().plusMinutes(cbFilm.getValue().getDuree());
            lblHeureFin.setText("Fin prévue : " + fin.format(FORMAT_HEURE));
        } catch (CineTrackException e) {
            lblHeureFin.setText("Fin prévue : --:--");
        }
    }

    private void viderFormulaire() {
        cbFilm.setValue(null);
        cbSalle.setValue(null);
        dpDate.setValue(null);
        txtHeureDebut.clear();
        lblHeureFin.setText("Fin prévue : --:--");
        tblSeances.getSelectionModel().clearSelection();
    }

    /** Affiche un texte quand aucun élément n'est sélectionné (sinon la liste paraît vide). */
    private <T> void afficherTexteVide(ComboBox<T> comboBox, String texte) {
        comboBox.setButtonCell(new ListCell<>() {
            @Override
            protected void updateItem(T item, boolean empty) {
                super.updateItem(item, empty);
                setText(empty || item == null ? texte : item.toString());
            }
        });
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