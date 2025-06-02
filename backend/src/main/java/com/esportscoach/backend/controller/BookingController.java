package com.esportscoach.backend.controller;

import com.esportscoach.backend.dto.BookingRequest;
import com.esportscoach.backend.model.Booking;
import com.esportscoach.backend.security.UserPrincipal;
import com.esportscoach.backend.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/*
    controlador que maneja las operaciones relacionadas con reservas (bookings):
    obtiene reservas de usuario, obtiene reserva por id, crea, cancela, actualiza estado y elimina reservas
*/
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    /*
        inyeccion del servicio de reservas que contiene la logica de negocio para gestionar bookings
    */
    @Autowired
    private BookingService bookingService;

    /*
        endpoint GET /api/bookings
        retorna la lista de reservas asociadas al usuario autenticado
        usa el objeto Authentication para extraer el id del usuario
    */
    @GetMapping
    public ResponseEntity<List<Booking>> getUserBookings(Authentication authentication) {
        UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();
        List<Booking> bookings = bookingService.getUserBookings(userPrincipal.getId());
        return ResponseEntity.ok(bookings);
    }

    /*
        endpoint GET /api/bookings/{id}
        busca una reserva por su identificador y devuelve 200 con el objeto booking
        o 404 si no se encontro la reserva
    */
    @GetMapping("/{id}")
    public ResponseEntity<Booking> getBookingById(@PathVariable String id) {
        return bookingService.getBookingById(id)
                .map(booking -> ResponseEntity.ok().body(booking))
                .orElse(ResponseEntity.notFound().build());
    }

    /*
        endpoint POST /api/bookings
        crea una nueva reserva usando datos del request y el usuario autenticado
        valida la entrada con @Valid y retorna 200 con el booking creado o 400 en caso de error
    */
    @PostMapping
    public ResponseEntity<Booking> createBooking(@Valid @RequestBody BookingRequest bookingRequest, Authentication authentication) {
        try {
            UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();
            Booking createdBooking = bookingService.createBooking(userPrincipal.getId(), bookingRequest);
            return ResponseEntity.ok(createdBooking);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /*
        endpoint PUT /api/bookings/{id}/cancel
        cancela una reserva existente si pertenece al usuario autenticado
        retorna 200 con el booking cancelado o 400 si ocurre un error
    */
    @PutMapping("/{id}/cancel")
    public ResponseEntity<Booking> cancelBooking(@PathVariable String id, Authentication authentication) {
        try {
            UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();
            Booking cancelledBooking = bookingService.cancelBooking(id, userPrincipal.getId());
            return ResponseEntity.ok(cancelledBooking);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /*
        endpoint PUT /api/bookings/{id}/status
        actualiza el estado de una reserva especificada por id
        recibe un objeto StatusUpdateRequest con el nuevo estado y retorna 200 con el booking actualizado o 404 si no existe
    */
    @PutMapping("/{id}/status")
    public ResponseEntity<Booking> updateBookingStatus(@PathVariable String id, @RequestBody StatusUpdateRequest request) {
        try {
            Booking updatedBooking = bookingService.updateBookingStatus(id, request.getStatus());
            return ResponseEntity.ok(updatedBooking);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /*
        endpoint DELETE /api/bookings/{id}
        elimina una reserva por su identificador, retorna 200 si se elimina correctamente o 404 si no se encontro
    */
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteBooking(@PathVariable String id) {
        try {
            bookingService.deleteBooking(id);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /*
        clase interna que representa el request para actualizar el estado de una reserva
        contiene un campo status de tipo Booking.BookingStatus
    */
    public static class StatusUpdateRequest {
        private Booking.BookingStatus status;

        public Booking.BookingStatus getStatus() {
            return status;
        }

        public void setStatus(Booking.BookingStatus status) {
            this.status = status;
        }
    }
}
