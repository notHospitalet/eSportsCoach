package com.esportscoach.backend.controller;

import com.esportscoach.backend.model.Service;
import com.esportscoach.backend.service.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/*
    controlador encargado de manejar las operaciones relacionadas con los servicios:
    obtiene todos los servicios, filtra por popularidad o tipo, obtiene por id, crea, actualiza y elimina servicios
*/
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/services")
public class ServiceController {

    /*
        inyeccion del servicio que contiene la logica de negocio para gestionar servicios
    */
    @Autowired
    private ServiceService serviceService;

    /*
        endpoint GET /api/services
        - si se recibe parametro 'isPopular' en true, retorna los servicios marcados como populares
        - si se recibe parametro 'type', intenta convertirlo a ServiceType y filtrar por tipo
        - si no se reciben filtros, retorna todos los servicios
        en caso de parametro 'type' invalido, retorna bad request
    */
    @GetMapping
    public ResponseEntity<List<Service>> getAllServices(
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Boolean isPopular) {
        
        List<Service> services;
        
        if (isPopular != null && isPopular) {
            services = serviceService.getPopularServices();
        } else if (type != null) {
            try {
                Service.ServiceType serviceType = Service.ServiceType.valueOf(type.toUpperCase());
                services = serviceService.getServicesByType(serviceType);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest().build();
            }
        } else {
            services = serviceService.getAllServices();
        }
        
        return ResponseEntity.ok(services);
    }

    /*
        endpoint GET /api/services/{id}
        busca un servicio por su identificador; si existe, retorna ok con el servicio, si no, retorna not found
    */
    @GetMapping("/{id}")
    public ResponseEntity<Service> getServiceById(@PathVariable String id) {
        return serviceService.getServiceById(id)
                .map(service -> ResponseEntity.ok().body(service))
                .orElse(ResponseEntity.notFound().build());
    }

    /*
        endpoint POST /api/services
        crea un nuevo servicio usando el objeto recibido en el cuerpo de la solicitud
        en caso de exito retorna ok con el servicio creado, en caso de error retorna bad request
    */
    @PostMapping
    public ResponseEntity<Service> createService(@RequestBody Service service) {
        try {
            Service createdService = serviceService.createService(service);
            return ResponseEntity.ok(createdService);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /*
        endpoint PUT /api/services/{id}
        actualiza un servicio existente identificado por 'id' con los detalles proporcionados;
        si se actualiza correctamente retorna ok con el servicio actualizado, si no existe retorna not found
    */
    @PutMapping("/{id}")
    public ResponseEntity<Service> updateService(@PathVariable String id, @RequestBody Service serviceDetails) {
        try {
            Service updatedService = serviceService.updateService(id, serviceDetails);
            return ResponseEntity.ok(updatedService);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /*
        endpoint DELETE /api/services/{id}
        elimina un servicio por su identificador; si se elimina retorna ok, si no existe retorna not found
    */
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteService(@PathVariable String id) {
        try {
            serviceService.deleteService(id);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
