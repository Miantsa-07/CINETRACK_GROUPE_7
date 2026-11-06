package cinetrack.dao;

import cinetrack.model.Reservation;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // ⚠️ MODIFIEZ CES LIGNES AVEC VOS IDENTIFIANTS POSTGRESQL ⚠️
    private static final String URL = "jdbc:postgresql://localhost:5432/cinetrack";
    private static final String USER = "postgres";
    private static final String PASSWORD = "votre_mot_de_passe";

    public boolean creerReservation(Reservation res) {
        // On n'insère pas le montantTotal : c'est votre trigger SQL qui le calcule !
        String sql = "INSERT INTO Reservation (dateReservation, nombrePlaces, idSeance, idClient, idTarif) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setInt(2, res.getNombrePlaces());
            pstmt.setInt(3, res.getIdSeance());
            pstmt.setInt(4, res.getIdClient());
            pstmt.setInt(5, res.getIdTarif());

            int lignes = pstmt.executeUpdate();
            return lignes > 0;

        } catch (SQLException e) {
            // Si le trigger RAISE EXCEPTION (plus de places), on l'affiche ici
            System.err.println("Erreur SQL : " + e.getMessage());
            return false;
        }
    }

    public List<Reservation> getReservationsParClient(int idClient) {
        List<Reservation> liste = new ArrayList<>();
        String sql = "SELECT * FROM Reservation WHERE idClient = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idClient);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Reservation r = new Reservation();
                r.setIdReservation(rs.getInt("idReservation"));
                r.setNombrePlaces(rs.getInt("nombrePlaces"));
                r.setMontantTotal(rs.getBigDecimal("montantTotal"));
                r.setIdSeance(rs.getInt("idSeance"));
                r.setIdClient(rs.getInt("idClient"));
                r.setIdTarif(rs.getInt("idTarif"));
                liste.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return liste;
    }
}