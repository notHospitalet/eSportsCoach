package com.esportscoach.backend.controller;

import com.esportscoach.backend.model.Testimonial;
import com.esportscoach.backend.service.TestimonialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/*
    controlador que maneja operaciones sobre testimonios:
    obtiene testimonios aprobados, todos (para admin), estadisticas, busca por id,
    crea, actualiza, aprueba y elimina testimonios
*/
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/testimonials")
public class TestimonialController {

    /*
        inyeccion del servicio que contiene la logica de negocio para gestionar testimonios
    */
    @Autowired
    private TestimonialService testimonialService;

    /*
        endpoint GET /api/testimonials
        retorna lista de testimonios aprobados para mostrar en la aplicacion
    */
    @GetMapping
    public ResponseEntity<List<Testimonial>> getAllTestimonials() {
        List<Testimonial> testimonials = testimonialService.getAllApprovedTestimonials();
        return ResponseEntity.ok(testimonials);
    }

    /*
        endpoint GET /api/testimonials/all
        retorna lista de todos los testimonios, sin importar si estan aprobados (uso admin)
    */
    @GetMapping("/all")
    public ResponseEntity<List<Testimonial>> getAllTestimonialsAdmin() {
        List<Testimonial> testimonials = testimonialService.getAllTestimonials();
        return ResponseEntity.ok(testimonials);
    }

    /*
        endpoint GET /api/testimonials/stats
        calcula estadisticas basicas: total de testimonios aprobados y calificacion promedio
        retorna un mapa con estos valores
    */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getTestimonialStats() {
        List<Testimonial> testimonials = testimonialService.getAllApprovedTestimonials();
        Double averageRating = testimonialService.getAverageRating();
        
        Map<String, Object> stats = Map.of(
            "totalTestimonials", testimonials.size(),
            "averageRating", averageRating
        );
        
        return ResponseEntity.ok(stats);
    }

    /*
        endpoint GET /api/testimonials/{id}
        busca un testimonio por id; si existe, retorna ok con el objeto, si no, retorna not found
    */
    @GetMapping("/{id}")
    public ResponseEntity<Testimonial> getTestimonialById(@PathVariable String id) {
        return testimonialService.getTestimonialById(id)
                .map(testimonial -> ResponseEntity.ok().body(testimonial))
                .orElse(ResponseEntity.notFound().build());
    }

    /*
        endpoint POST /api/testimonials
        crea un nuevo testimonio usando el objeto recibido en el cuerpo de la solicitud
        retorna ok con el testimonio creado o bad request en caso de error
    */
    @PostMapping
    public ResponseEntity<Testimonial> createTestimonial(@RequestBody Testimonial testimonial) {
        try {
            Testimonial createdTestimonial = testimonialService.createTestimonial(testimonial);
            return ResponseEntity.ok(createdTestimonial);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /*
        endpoint PUT /api/testimonials/{id}
        actualiza un testimonio existente identificado por id con los detalles proporcionados;
        si se actualiza correctamente retorna ok con el testimonio actualizado, si no existe retorna not found
    */
    @PutMapping("/{id}")
    public ResponseEntity<Testimonial> updateTestimonial(@PathVariable String id, @RequestBody Testimonial testimonialDetails) {
        try {
            Testimonial updatedTestimonial = testimonialService.updateTestimonial(id, testimonialDetails);
            return ResponseEntity.ok(updatedTestimonial);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /*
        endpoint PUT /api/testimonials/{id}/approve
        marca un testimonio como aprobado; retorna ok con el testimonio aprobado o not found si no existe
    */
    @PutMapping("/{id}/approve")
    public ResponseEntity<Testimonial> approveTestimonial(@PathVariable String id) {
        try {
            Testimonial approvedTestimonial = testimonialService.approveTestimonial(id);
            return ResponseEntity.ok(approvedTestimonial);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /*
        endpoint DELETE /api/testimonials/{id}
        elimina un testimonio por su identificador; si se elimina retorna ok, si no existe retorna not found
    */
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTestimonial(@PathVariable String id) {
        try {
            testimonialService.deleteTestimonial(id);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
