package com.esportscoach.backend.repository;

import com.esportscoach.backend.model.Service;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/*
    repositorio para gestionar operaciones CRUD sobre la coleccion "services"
    incluye metodos personalizados para obtener servicios activos, populares, por tipo y por coach
*/
@Repository
public interface ServiceRepository extends MongoRepository<Service, String> {

    /*
        obtiene servicios que estan activos (isActive = true)
    */
    List<Service> findByIsActiveTrue();

    /*
        obtiene servicios marcados como populares (isPopular = true)
    */
    List<Service> findByIsPopularTrue();

    /*
        obtiene servicios filtrados por su tipo (INDIVIDUAL, MONTHLY, COURSE, GUIDE, TEAM)
    */
    List<Service> findByType(Service.ServiceType type);

    /*
        obtiene todos los servicios ofrecidos por un coach especifico
    */
    List<Service> findByCoachId(String coachId);

    /*
        obtiene servicios activos de un tipo determinado
    */
    List<Service> findByIsActiveTrueAndType(Service.ServiceType type);

    /*
        obtiene servicios que estan activos y ademas son populares
    */
    List<Service> findByIsActiveTrueAndIsPopularTrue();
}
