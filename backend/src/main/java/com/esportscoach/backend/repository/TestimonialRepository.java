package com.esportscoach.backend.repository;

import com.esportscoach.backend.model.Testimonial;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

/*
    repositorio que gestiona operaciones CRUD sobre la coleccion "testimonials"
    y provee consultas personalizadas para obtener testimonios aprobados, por usuario, calificacion o estado
*/
@Repository
public interface TestimonialRepository extends MongoRepository<Testimonial, String> {

    /*
        consulta personalizada para obtener testimonios aprobados ordenados por fecha descendente:
        - filtra por isApproved = true
        - aplica ordenamiento por campo date en orden descendente
    */
    @Query(value = "{'isApproved': true}", sort = "{'date': -1}")
    List<Testimonial> findApprovedTestimonialsSortedByDateDesc();

    /*
        metodos derivados de convenciones de spring data para filtrado:
        - findByUserId: obtiene testimonios creados por un usuario especifico
        - findByRating: obtiene testimonios con una calificacion exacta
        - findByIsApprovedTrue: obtiene todos los testimonios que han sido aprobados
    */
    List<Testimonial> findByUserId(String userId);
    List<Testimonial> findByRating(Integer rating);
    List<Testimonial> findByIsApprovedTrue(); // uso general para obtener solo testimonios aprobados

    /*
        metodos para obtener todos los testimonios ordenados o filtrados por estado:
        - findAllByOrderByDateDesc: obtiene todos los testimonios, sin importar su estado, ordenados por fecha descendente
        - findAllByIsApprovedOrderByDateDesc: obtiene testimonios filtrados por el valor de isApproved (true o false) y ordenados por fecha descendente
    */
    List<Testimonial> findAllByOrderByDateDesc(); // usado por admin para listar testimonios pendientes y aprobados
    List<Testimonial> findAllByIsApprovedOrderByDateDesc(Boolean isApproved); // uso adicional para filtrar por estado y ordenar
}
