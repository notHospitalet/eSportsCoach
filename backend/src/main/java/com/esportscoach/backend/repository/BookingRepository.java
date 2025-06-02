package com.esportscoach.backend.repository;

import com.esportscoach.backend.model.Booking;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/*
    repositorio que extiende mongo repository para gestionar operaciones CRUD sobre la coleccion "bookings"
    incluye metodos personalizados para buscar reservas por diferentes criterios
*/
@Repository
public interface BookingRepository extends MongoRepository<Booking, String> {

    /*
        metodo para obtener todas las reservas asociadas a un usuario especifico
    */
    List<Booking> findByUserId(String userId);

    /*
        metodo para obtener todas las reservas asociadas a un coach especifico
    */
    List<Booking> findByCoachId(String coachId);

    /*
        metodo para obtener todas las reservas de un servicio concreto
    */
    List<Booking> findByServiceId(String serviceId);

    /*
        metodo para obtener reservas filtradas por su estado (PENDING, CONFIRMED, etc.)
    */
    List<Booking> findByStatus(Booking.BookingStatus status);

    /*
        metodo para obtener reservas de un usuario ordenadas por fecha descendente (las mas recientes primero)
    */
    List<Booking> findByUserIdOrderByDateDesc(String userId);

    /*
        metodo para obtener reservas de un coach ordenadas por fecha descendente
    */
    List<Booking> findByCoachIdOrderByDateDesc(String coachId);
}
