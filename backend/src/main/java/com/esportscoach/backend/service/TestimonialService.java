package com.esportscoach.backend.service;

import com.esportscoach.backend.model.Testimonial;
import com.esportscoach.backend.repository.TestimonialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/*
    servicio que maneja la logica de negocio para testimonios:
    incluye obtencion de testimonios aprobados, todos (para admin), por usuario,
    creacion, actualizacion, aprobacion, eliminacion y calculo de calificacion promedio
*/
@Service
public class TestimonialService {

    /*
        inyeccion del repositorio que opera sobre la coleccion "testimonials" en mongodb
    */
    @Autowired
    private TestimonialRepository testimonialRepository;

    /*
        metodo para obtener todos los testimonios aprobados, ordenados por fecha descendente
        utiliza el metodo personalizado findApprovedTestimonialsSortedByDateDesc del repositorio
    */
    public List<Testimonial> getAllApprovedTestimonials() {
        return testimonialRepository.findApprovedTestimonialsSortedByDateDesc();
    }

    /*
        metodo para obtener todos los testimonios sin importar estado de aprobacion,
        ordenados por fecha descendente filtrando inicialmente por isApproved = false
        (uso principal para administracion de testimonios pendientes)
    */
    public List<Testimonial> getAllTestimonials() {
        return testimonialRepository.findAllByIsApprovedOrderByDateDesc(false);
    }

    /*
        metodo para obtener testimonios creados por un usuario especifico
        recibe userId y delega en findByUserId del repositorio
    */
    public List<Testimonial> getTestimonialsByUser(String userId) {
        return testimonialRepository.findByUserId(userId);
    }

    /*
        metodo para buscar un testimonio por su identificador unico,
        retorna un Optional<Testimonial> para manejar ausencia de resultado
    */
    public Optional<Testimonial> getTestimonialById(String id) {
        return testimonialRepository.findById(id);
    }

    /*
        metodo para crear un nuevo testimonio enviado por un usuario:
        - asigna fecha actual a campos date, createdAt y updatedAt
        - establece isApproved en false para requerir aprobacion
        - guarda el testimonio en la base de datos
    */
    public Testimonial createTestimonial(Testimonial testimonial) {
        testimonial.setDate(LocalDateTime.now());
        testimonial.setCreatedAt(LocalDateTime.now());
        testimonial.setUpdatedAt(LocalDateTime.now());
        testimonial.setIsApproved(false); // requiere aprobacion
        return testimonialRepository.save(testimonial);
    }

    /*
        metodo para actualizar un testimonio existente:
        - busca el testimonio por id, lanza excepcion si no existe
        - actualiza campos de nombre, comentario, calificacion y rangos
        - actualiza updatedAt con fecha actual
        - guarda y retorna el testimonio modificado
    */
    public Testimonial updateTestimonial(String id, Testimonial testimonialDetails) {
        Testimonial testimonial = testimonialRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("testimonial not found with id: " + id));

        testimonial.setName(testimonialDetails.getName());
        testimonial.setComment(testimonialDetails.getComment());
        testimonial.setRating(testimonialDetails.getRating());
        testimonial.setInitialRank(testimonialDetails.getInitialRank());
        testimonial.setCurrentRank(testimonialDetails.getCurrentRank());
        testimonial.setUpdatedAt(LocalDateTime.now());

        return testimonialRepository.save(testimonial);
    }

    /*
        metodo para aprobar un testimonio:
        - busca el testimonio por id, lanza excepcion si no existe
        - marca isApproved en true y actualiza updatedAt
        - guarda y retorna el testimonio aprobado
    */
    public Testimonial approveTestimonial(String id) {
        Testimonial testimonial = testimonialRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("testimonial not found with id: " + id));

        testimonial.setIsApproved(true);
        testimonial.setUpdatedAt(LocalDateTime.now());

        return testimonialRepository.save(testimonial);
    }

    /*
        metodo para eliminar un testimonio por su identificador,
        delega en deleteById del repositorio
    */
    public void deleteTestimonial(String id) {
        testimonialRepository.deleteById(id);
    }

    /*
        metodo para calcular la calificacion promedio de todos los testimonios aprobados:
        - obtiene lista de testimonios con isApproved = true
        - si la lista esta vacia, retorna 0.0
        - suma las calificaciones y divide por la cantidad de testimonios
    */
    public Double getAverageRating() {
        List<Testimonial> approvedTestimonials = testimonialRepository.findByIsApprovedTrue();
        if (approvedTestimonials.isEmpty()) {
            return 0.0;
        }

        double sum = approvedTestimonials.stream()
                .mapToInt(Testimonial::getRating)
                .sum();

        return sum / approvedTestimonials.size();
    }
}
