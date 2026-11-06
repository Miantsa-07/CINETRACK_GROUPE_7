package cinetrack.controller;

import cinetrack.model.Reservation;
import cinetrack.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reservations")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private ReservationDAO reservationDAO;

    // Route pour créer une réservation
    @PostMapping
    public ResponseEntity<?> creer(@RequestBody Reservation reservation) {
        try {
            Reservation nouvelleResa = reservationService.creerReservation(reservation);
            return ResponseEntity.ok(nouvelleResa);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Route pour voir l'historique d'un client
    @GetMapping("/client/{idClient}")
    public List<Reservation> getParClient(@PathVariable Integer idClient) {
        return reservationDAO.findByClientIdClient(idClient);
    }
}