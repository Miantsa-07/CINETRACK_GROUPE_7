package cinetrack.controller;

import cinetrack.exception.CineTrackException;
import cinetrack.exception.ValidationException;
import cinetrack.model.Film;
import cinetrack.service.FilmService;
import cinetrack.util.Session;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;

import java.util.List;

public class FilmController {

    private static final String TOUS_GENRES = "Tous les genres";
    private static final List<String> GENRES = List.of(
            "Action", "Animation", "Comédie", "Drame", "Horreur", "Science-fiction", "Thriller", "Autre");

    @FXML private TextField txtRecherche;
    @FXML private ComboBox<String> cbGenreFiltre;
    @FXML private TableView<Film> tblFilms;
    @FXML private TableColumn<Film, String> colTitre;
    @FXML private TableColumn<Film, String> colGenre;
    @FXML private TableColumn<Film, Integer> colDuree;
    @FXML private TableColumn<Film, String> colNote;
    @FXML private TextField txtTitre;
    @FXML private ComboBox<String> cbGenre;
    @FXML private TextField txtDuree;
    @FXML private TextArea txtSynopsis;
    @FXML private Label lblMessage;
    @FXML private Button btnAjouter;
    @FXML private Button btnModifier;
    @FXML private Button btnSupprimer;

    private final FilmService filmService = new FilmService();
    private final ObservableList<Film> films = FXCollections.observableArrayList();

    @FXML
    public void initialize() {
        // Colonnes du tableau
        colTitre.setCellValueFactory(new PropertyValueFactory<>("titre"));
        colGenre.setCellValueFactory(new PropertyValueFactory<>("genre"));
        colDuree.setCellValueFactory(new PropertyValueFactory<>("duree"));
        colNote.setCellValueFactory(cd -> {
            Double note = cd.getValue().getNoteMoyenne();
            return new SimpleStringProperty(note == null || note == 0 ? "-" : String.format("%.1f / 5", note));
        });
        tblFilms.setItems(films);

        // Listes déroulantes
        cbGenre.setItems(FXCollections.observableArrayList(GENRES));
        ObservableList<String> genresFiltre = FXCollections.observableArrayList(TOUS_GENRES);
        genresFiltre.addAll(GENRES);
        cbGenreFiltre.setItems(genresFiltre);
        cbGenreFiltre.setValue(TOUS_GENRES);

        // Clic sur une ligne : remplit le formulaire
        tblFilms.getSelectionModel().selectedItemProperty().addListener((obs, ancien, film) -> {
            if (film != null) {
                remplirFormulaire(film);
            }
        });

        // Droits : seul l'administrateur peut supprimer
        boolean admin = Session.estAdmin();
        btnSupprimer.setVisible(admin);
        btnSupprimer.setManaged(admin);

        onRechercher();
    }

    // ===== Actions =====

    @FXML
    private void onRechercher() {
        try {
            String titre = txtRecherche.getText() == null ? "" : txtRecherche.getText().trim();
            String genre = TOUS_GENRES.equals(cbGenreFiltre.getValue()) ? null : cbGenreFiltre.getValue();
            films.setAll(filmService.rechercher(titre, genre));
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    @FXML
    private void onAjouter() {
        try {
            filmService.ajouter(lireFormulaire());
            viderFormulaire();
            onRechercher();
            afficherSucces("Film ajouté.");
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    @FXML
    private void onModifier() {
        Film selection = tblFilms.getSelectionModel().getSelectedItem();
        if (selection == null) {
            afficherErreur("Sélectionnez un film dans le tableau.");
            return;
        }
        try {
            Film film = lireFormulaire();
            film.setId(selection.getId());
            filmService.modifier(film);
            viderFormulaire();
            onRechercher();
            afficherSucces("Film modifié.");
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    @FXML
    private void onSupprimer() {
        Film selection = tblFilms.getSelectionModel().getSelectedItem();
        if (selection == null) {
            afficherErreur("Sélectionnez un film dans le tableau.");
            return;
        }
        Alert confirmation = new Alert(Alert.AlertType.CONFIRMATION,
                "Supprimer le film « " + selection.getTitre() + " » ?", ButtonType.YES, ButtonType.NO);
        confirmation.setHeaderText(null);
        if (confirmation.showAndWait().orElse(ButtonType.NO) != ButtonType.YES) {
            return;
        }
        try {
            filmService.supprimer(selection.getId());
            viderFormulaire();
            onRechercher();
            afficherSucces("Film supprimé.");
        } catch (CineTrackException e) {
            afficherErreur(e.getMessage());
        }
    }

    // ===== Outils =====

    /** Lit le formulaire. Seule la conversion de la durée est vérifiée ici, le reste est validé par le service. */
    private Film lireFormulaire() {
        String texte = txtDuree.getText() == null ? "" : txtDuree.getText().trim();
        int duree;
        try {
            duree = Integer.parseInt(texte);
        } catch (NumberFormatException e) {
            throw new ValidationException("La durée doit être un nombre entier (en minutes).");
        }
        return new Film(txtTitre.getText(), cbGenre.getValue(), duree, txtSynopsis.getText());
    }

    private void remplirFormulaire(Film film) {
        txtTitre.setText(film.getTitre());
        cbGenre.setValue(film.getGenre());
        txtDuree.setText(String.valueOf(film.getDuree()));
        txtSynopsis.setText(film.getSynopsis());
        lblMessage.setText("");
    }

    private void viderFormulaire() {
        txtTitre.clear();
        cbGenre.setValue(null);
        txtDuree.clear();
        txtSynopsis.clear();
        tblFilms.getSelectionModel().clearSelection();
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