package com.esportscoach.backend.service;

import com.esportscoach.backend.dto.BookingRequest;
import com.esportscoach.backend.model.Booking;
import com.esportscoach.backend.model.Service;
import com.esportscoach.backend.model.User;
import com.esportscoach.backend.repository.BookingRepository;
import com.esportscoach.backend.repository.ServiceRepository;
import com.esportscoach.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/*
    servicio que gestiona la logica de negocio para reservas (bookings):
    incluye obtencion de reservas por usuario o coach, creacion, actualizacion de estado, cancelacion y eliminacion
*/
@org.springframework.stereotype.Service
public class BookingService {

    /*
        inyeccion de los repositorios y servicio de correo necesarios:
        - bookingRepository: operaciones CRUD sobre reservas
        - serviceRepository: para obtener datos del servicio reservado
        - userRepository: para obtener datos del usuario que reserva
        - emailService: para envio de correos relacionados con reservas
    */
    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailService emailService;

    /*
        obtiene todas las reservas de un usuario, ordenadas por fecha desc:
        - recibe userId
        - delega en bookingRepository.findByUserIdOrderByDateDesc
    */
    public List<Booking> getUserBookings(String userId) {
        return bookingRepository.findByUserIdOrderByDateDesc(userId);
    }

    /*
        obtiene todas las reservas asociadas a un coach, ordenadas por fecha desc:
        - recibe coachId
        - delega en bookingRepository.findByCoachIdOrderByDateDesc
    */
    public List<Booking> getCoachBookings(String coachId) {
        return bookingRepository.findByCoachIdOrderByDateDesc(coachId);
    }

    /*
        busca una reserva por su id:
        - devuelve un Optional<Booking> para manejar ausencia de la reserva
    */
    public Optional<Booking> getBookingById(String id) {
        return bookingRepository.findById(id);
    }

    /*
        crea una nueva reserva:
        - busca el servicio por id, lanza excepcion si no existe
        - busca el usuario que reserva, lanza excepcion si no existe
        - crea un objeto Booking con datos de usuario, servicio, coach, fecha, notas, monto y estados iniciales
        - guarda la reserva en la base de datos
        - intenta enviar correo de confirmacion al usuario; en caso de falla, solo se loguea el error
        - retorna la reserva guardada
    */
    public Booking createBooking(String userId, BookingRequest bookingRequest) {
        Service service = serviceRepository.findById(bookingRequest.getServiceId())
                .orElseThrow(() -> new RuntimeException("service not found"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("user not found"));

        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setServiceId(service.getId());
        booking.setCoachId(service.getCoachId());
        booking.setDate(bookingRequest.getDate());
        booking.setNotes(bookingRequest.getNotes());
        booking.setAmount(service.getPrice());
        booking.setStatus(Booking.BookingStatus.PENDING);
        booking.setPaymentStatus(Booking.PaymentStatus.PENDING);

        Booking savedBooking = bookingRepository.save(booking);

        // envio de correo de confirmacion de reserva
        try {
            emailService.sendBookingConfirmationEmail(
                user.getEmail(), 
                user.getUsername(), 
                service.getTitle(), 
                booking.getDate()
            );

            // Enviar notificación al coach
            User coach = userRepository.findById(service.getCoachId())
                .orElseThrow(() -> new RuntimeException("coach not found"));
            
            emailService.sendNewBookingNotificationEmail(
                coach.getEmail(),
                user.getUsername(),
                user.getEmail(),
                service.getTitle(),
                booking.getDate()
            );
        } catch (Exception e) {
            System.err.println("failed to send booking confirmation email: " + e.getMessage());
        }

        return savedBooking;
    }

    /*
        actualiza el estado de una reserva:
        - busca la reserva por id, lanza excepcion si no existe
        - modifica el campo status y actualiza el campo updatedAt
        - guarda y retorna la reserva actualizada
    */
    public Booking updateBookingStatus(String id, Booking.BookingStatus status) {
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("booking not found with id: " + id));

        booking.setStatus(status);
        booking.setUpdatedAt(LocalDateTime.now());

        return bookingRepository.save(booking);
    }

    /*
        cancela una reserva:
        - busca la reserva por id, lanza excepcion si no existe
        - verifica que la reserva pertenezca al usuario que la cancela, lanza excepcion si no coincide
        - actualiza status a CANCELLED y campo updatedAt
        - guarda y retorna la reserva cancelada
    */
    public Booking cancelBooking(String id, String userId) {
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("booking not found with id: " + id));

        // verificacion de propiedad de la reserva
        if (!booking.getUserId().equals(userId)) {
            throw new RuntimeException("unauthorized to cancel this booking");
        }

        booking.setStatus(Booking.BookingStatus.CANCELLED);
        booking.setUpdatedAt(LocalDateTime.now());

        return bookingRepository.save(booking);
    }

    /*
        elimina una reserva por su id:
        - delega en bookingRepository.deleteById
        - lanza excepcion si no existe (manejada por el controlador)
    */
    public void deleteBooking(String id) {
        bookingRepository.deleteById(id);
    }
}
