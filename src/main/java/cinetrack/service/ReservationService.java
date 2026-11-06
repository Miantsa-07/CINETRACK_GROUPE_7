package cinetrack.service;

import cinetrack.dao.ReservationDAO;
import cinetrack.model.Reservation;
import cinetrack.model.Seance;
import cinetrack.dao.SeanceDAO; // À créer si ce n'est pas fait
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;

@Service
public class ReservationService {

    @Autowired
    private ReservationDAO reservationDAO;

    @Autowired
    private SeanceDAO seanceDAO;

    @Transactional // Très important : si une erreur arrive, tout est annulé
    public Reservation creerReservation(Reservation res) {
        // 1. Vérifier les places disponibles
        Seance seance = res.getSeance();
        if (seance.getPlacesRestantes() < res.getNombrePlaces()) {
            throw new RuntimeException("Pas assez de places disponibles !");
        }

        // 2. Calculer le montant total
        BigDecimal prix = res.getTarif().getPrixUnitaire();
        BigDecimal total = prix.multiply(new BigDecimal(res.getNombrePlaces()));
        res.setMontantTotal(total);

        // 3. Mettre à jour les places de la séance
        seance.setPlacesRestantes(seance.getPlacesRestantes() - res.getNombrePlaces());
        seanceDAO.save(seance);

        // 4. Sauvegarder la réservation
        return reservationDAO.save(res);
    }
}